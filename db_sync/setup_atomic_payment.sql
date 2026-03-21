-- ============================================
-- Atomic Payment RPCs for Concurrent Safety
-- Handles 1000+ simultaneous payments safely.
-- Run this in Supabase SQL Editor AFTER setup_payment_safety.sql.
-- ============================================


-- ============================================
-- 1. INITIATE PAYMENT (ATOMIC)
-- Validates fees, checks locks, creates payment + details in one transaction.
-- Eliminates TOCTOU gap between check_fees_locked and insert.
-- ============================================
CREATE OR REPLACE FUNCTION initiate_payment_atomic(
  p_car_id INTEGER,
  p_ins_id INTEGER,
  p_inscode VARCHAR,
  p_stu_id BIGINT,
  p_yr_id INTEGER,
  p_yrlabel VARCHAR,
  p_total_amount NUMERIC,
  p_created_by VARCHAR,
  p_items JSONB  -- array of {dem_id, yr_id, yrlabel, ins_id, amount}
)
RETURNS INTEGER AS $$
DECLARE
  v_pay_id INTEGER;
  v_item JSONB;
  v_dem_id BIGINT;
  v_balance NUMERIC;
  v_paid_status CHAR(1);
  v_locked_count INTEGER;
BEGIN
  -- 1. Lock and validate each fee demand (FOR UPDATE prevents concurrent modification)
  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    v_dem_id := (v_item->>'dem_id')::BIGINT;

    SELECT balancedue, paidstatus INTO v_balance, v_paid_status
    FROM feedemand
    WHERE dem_id = v_dem_id AND activestatus = 1
    FOR UPDATE;  -- Row-level lock: serializes concurrent access to this fee

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Fee demand % not found or inactive', v_dem_id;
    END IF;

    IF v_paid_status = 'P' OR v_balance <= 0 THEN
      RAISE EXCEPTION 'Fee demand % is already fully paid', v_dem_id;
    END IF;
  END LOOP;

  -- 2. Check if any of these fees are already being paid (initiated payments)
  --    This is now inside the same transaction as the lock, eliminating TOCTOU
  SELECT COUNT(*) INTO v_locked_count
  FROM paymentdetails pd
  INNER JOIN payment p ON p.pay_id = pd.pay_id
  WHERE pd.dem_id IN (
    SELECT (elem->>'dem_id')::BIGINT FROM jsonb_array_elements(p_items) AS elem
  )
  AND p.paystatus = 'I'
  AND p.createdat > NOW() - INTERVAL '30 minutes';  -- Stale locks expire after 30 min

  IF v_locked_count > 0 THEN
    RAISE EXCEPTION 'One or more fees are currently being processed by another payment. Please wait and try again.';
  END IF;

  -- 3. Clean up any stale initiated payments for this student (older than 30 min)
  DELETE FROM paymentdetails
  WHERE pay_id IN (
    SELECT pay_id FROM payment
    WHERE stu_id = p_stu_id AND paystatus = 'I'
    AND createdat <= NOW() - INTERVAL '30 minutes'
  );
  DELETE FROM payment
  WHERE stu_id = p_stu_id AND paystatus = 'I'
  AND createdat <= NOW() - INTERVAL '30 minutes';

  -- 4. Create payment record (paystatus = 'I' for Initiated)
  INSERT INTO payment (ins_id, inscode, stu_id, yr_id, yrlabel, transtotalamount, transcurrency, paydate, paystatus, createdby)
  VALUES (p_ins_id, p_inscode, p_stu_id, p_yr_id, p_yrlabel, p_total_amount, 'INR', NOW(), 'I', p_created_by)
  RETURNING pay_id INTO v_pay_id;

  -- 5. Insert payment details
  INSERT INTO paymentdetails (pay_id, dem_id, yr_id, yrlabel, ins_id, transcurrency, transtotalamount)
  SELECT
    v_pay_id,
    (elem->>'dem_id')::BIGINT,
    (elem->>'yr_id')::INTEGER,
    elem->>'yrlabel',
    (elem->>'ins_id')::INTEGER,
    'INR',
    (elem->>'amount')::NUMERIC
  FROM jsonb_array_elements(p_items) AS elem;

  -- 6. Mark shopping cart as initiated
  UPDATE shoppingcart SET carinitiated = 'I' WHERE car_id = p_car_id;

  RETURN v_pay_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 2. COMPLETE PAYMENT (ATOMIC)
-- Generates pay number, updates payment + feedemand, deletes cart — all in one transaction.
-- Uses FOR UPDATE on feedemand rows to prevent concurrent balance corruption.
-- ============================================
CREATE OR REPLACE FUNCTION complete_payment_atomic(
  p_pay_id INTEGER,
  p_pay_method VARCHAR,
  p_pay_reference VARCHAR,
  p_items JSONB  -- array of {dem_id, amount}
)
RETURNS TEXT AS $$
DECLARE
  v_pay_number TEXT;
  v_item JSONB;
  v_dem_id BIGINT;
  v_amount NUMERIC;
  v_current_paid NUMERIC;
  v_current_balance NUMERIC;
  v_new_paid NUMERIC;
  v_new_balance NUMERIC;
  v_stu_id BIGINT;
  v_pay_status CHAR(1);
BEGIN
  -- 0. Validate payment exists and is in 'I' (Initiated) state
  SELECT paystatus, stu_id INTO v_pay_status, v_stu_id
  FROM payment
  WHERE pay_id = p_pay_id
  FOR UPDATE;  -- Lock the payment row to prevent double-completion

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Payment % not found', p_pay_id;
  END IF;

  IF v_pay_status != 'I' THEN
    RAISE EXCEPTION 'Payment % is not in Initiated state (current: %)', p_pay_id, v_pay_status;
  END IF;

  -- 1. Generate payment number atomically (reuses existing RPC logic)
  v_pay_number := generate_payment_number();

  -- 2. Update payment record to Complete
  UPDATE payment SET
    paystatus = 'C',
    paymethod = p_pay_method,
    payreference = p_pay_reference,
    paynumber = v_pay_number,
    paydate = NOW()
  WHERE pay_id = p_pay_id;

  -- 3. Update each feedemand with FOR UPDATE lock (prevents concurrent balance corruption)
  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    v_dem_id := (v_item->>'dem_id')::BIGINT;
    v_amount := (v_item->>'amount')::NUMERIC;

    -- Lock the row, read current values
    SELECT paidamount, balancedue INTO v_current_paid, v_current_balance
    FROM feedemand
    WHERE dem_id = v_dem_id AND activestatus = 1
    FOR UPDATE;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Fee demand % not found', v_dem_id;
    END IF;

    v_new_paid := COALESCE(v_current_paid, 0) + v_amount;
    v_new_balance := COALESCE(v_current_balance, 0) - v_amount;

    IF v_new_balance < 0 THEN
      v_new_balance := 0;
    END IF;

    UPDATE feedemand SET
      paidamount = v_new_paid,
      balancedue = v_new_balance,
      paidstatus = CASE WHEN v_new_balance <= 0 THEN 'P' ELSE 'U' END,
      pay_id = p_pay_id
    WHERE dem_id = v_dem_id;
  END LOOP;

  -- 4. Delete ALL shopping carts for this student (current + any stale ones)
  DELETE FROM shoppingcartdetails
  WHERE car_id IN (SELECT car_id FROM shoppingcart WHERE stu_id = v_stu_id);

  DELETE FROM shoppingcart WHERE stu_id = v_stu_id;

  RETURN v_pay_number;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 3. FAIL PAYMENT (ATOMIC)
-- Marks payment as Failed, generates pay number, resets cart — all in one transaction.
-- ============================================
CREATE OR REPLACE FUNCTION fail_payment_atomic(
  p_pay_id INTEGER,
  p_car_id INTEGER,
  p_pay_reference VARCHAR DEFAULT NULL,
  p_error_reason VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
  v_pay_number TEXT;
  v_pay_status CHAR(1);
BEGIN
  -- 0. Validate payment is in 'I' state
  SELECT paystatus INTO v_pay_status
  FROM payment
  WHERE pay_id = p_pay_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Payment % not found', p_pay_id;
  END IF;

  IF v_pay_status != 'I' THEN
    RAISE EXCEPTION 'Payment % is not in Initiated state (current: %)', p_pay_id, v_pay_status;
  END IF;

  -- 1. Generate payment number atomically
  v_pay_number := generate_payment_number();

  -- 2. Mark payment as Failed
  UPDATE payment SET
    paystatus = 'F',
    paymethod = 'razorpay',
    paynumber = v_pay_number,
    payreference = COALESCE(p_pay_reference, payreference),
    paydate = NOW()
  WHERE pay_id = p_pay_id;

  -- 3. Reset shopping cart back to 'N' (not initiated) so user can retry
  UPDATE shoppingcart SET carinitiated = 'N' WHERE car_id = p_car_id;

  RETURN v_pay_number;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 4. Update check_fees_locked with stale lock expiry (30 min)
-- Prevents abandoned payments from blocking forever.
-- ============================================
CREATE OR REPLACE FUNCTION check_fees_locked(p_dem_ids BIGINT[])
RETURNS TABLE(dem_id BIGINT) AS $$
BEGIN
  RETURN QUERY
  SELECT pd.dem_id
  FROM paymentdetails pd
  INNER JOIN payment p ON p.pay_id = pd.pay_id
  WHERE pd.dem_id = ANY(p_dem_ids)
    AND p.paystatus = 'I'
    AND p.createdat > NOW() - INTERVAL '30 minutes';  -- Stale locks expire
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 5. DATABASE CONSTRAINTS for data integrity
-- ============================================

-- Prevent negative balance on feedemand
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'feedemand_balancedue_nonnegative'
  ) THEN
    ALTER TABLE feedemand ADD CONSTRAINT feedemand_balancedue_nonnegative CHECK (balancedue >= 0);
  END IF;
END $$;

-- Unique paynumber (already in setup_payment_safety.sql, but ensure it exists)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'payment_paynumber_unique'
  ) THEN
    ALTER TABLE payment ADD CONSTRAINT payment_paynumber_unique UNIQUE (paynumber);
  END IF;
END $$;

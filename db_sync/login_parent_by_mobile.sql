-- ============================================
-- Single RPC for parent mobile login
-- Combines parent lookup + password verification
-- into one database round-trip for faster sign-in
-- ============================================

CREATE OR REPLACE FUNCTION login_parent_by_mobile(
    p_mobile TEXT,
    p_plain_password TEXT
)
RETURNS JSON AS $$
DECLARE
    v_parent RECORD;
    v_is_valid BOOLEAN;
BEGIN
    -- Find parent by mobile number
    SELECT * INTO v_parent
    FROM public.parents
    WHERE payinchargemob = p_mobile::BIGINT
    AND activestatus = 1;

    IF NOT FOUND THEN
        RETURN json_build_object('success', false, 'error', 'Mobile number not registered');
    END IF;

    -- Check if password is set
    IF v_parent.parpassword IS NULL OR v_parent.parpassword = '' THEN
        RETURN json_build_object('success', false, 'error', 'Account setup incomplete. Please create your account first.');
    END IF;

    -- Verify password
    v_is_valid := (v_parent.parpassword = crypt(p_plain_password, v_parent.parpassword));

    IF NOT v_is_valid THEN
        RETURN json_build_object('success', false, 'error', 'Invalid password');
    END IF;

    -- Return success with parent data
    RETURN json_build_object(
        'success', true,
        'parent', row_to_json(v_parent)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

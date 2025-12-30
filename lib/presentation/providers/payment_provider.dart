import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/payment_model.dart';
import 'auth_provider.dart';
import 'student_provider.dart';

/// Fetch payments from Supabase 'payment' table
/// Note: The payment table stores payment records linked to shopping carts
final paymentsProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final student = ref.watch(selectedStudentProvider);
  final client = ref.watch(supabaseClientProvider);

  if (student == null) return [];

  try {
    // Get payments for the student's institution
    final response = await client
        .from('payment')
        .select('*')
        .eq('ins_id', student.insId)
        .eq('activestatus', 1)
        .order('createdat', ascending: false);

    return (response as List<dynamic>)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching payments: $e');
    return [];
  }
});

/// Fetch payments by institution ID
final paymentsByInstitutionProvider = FutureProvider.family<List<PaymentModel>, int>((ref, insId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('payment')
        .select('*')
        .eq('ins_id', insId)
        .eq('activestatus', 1)
        .order('createdat', ascending: false);

    return (response as List<dynamic>)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching payments by institution: $e');
    return [];
  }
});

/// Fetch a single payment by ID
final paymentByIdProvider = FutureProvider.family<PaymentModel?, int>((ref, payId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('payment')
        .select('*')
        .eq('pay_id', payId)
        .maybeSingle();

    if (response != null) {
      return PaymentModel.fromJson(response);
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching payment by ID: $e');
    return null;
  }
});

/// Recent payments (last 5)
final recentPaymentsProvider = Provider<List<PaymentModel>>((ref) {
  final paymentsAsync = ref.watch(paymentsProvider);
  return paymentsAsync.maybeWhen(
    data: (payments) => payments.take(5).toList(),
    orElse: () => [],
  );
});

/// Successful payments only
final successfulPaymentsProvider = Provider<List<PaymentModel>>((ref) {
  final paymentsAsync = ref.watch(paymentsProvider);
  return paymentsAsync.maybeWhen(
    data: (payments) => payments
        .where((p) => p.paystatus == 'C')
        .toList(),
    orElse: () => [],
  );
});

/// Shopping cart provider
final shoppingCartProvider = FutureProvider.family<ShoppingCartModel?, int>((ref, carId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('shoppingcart')
        .select('*')
        .eq('car_id', carId)
        .maybeSingle();

    if (response != null) {
      return ShoppingCartModel.fromJson(response);
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching shopping cart: $e');
    return null;
  }
});

/// Shopping cart details provider
final shoppingCartDetailsProvider = FutureProvider.family<List<ShoppingCartDetailModel>, int>((ref, carId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('shoppingcartdetails')
        .select('*')
        .eq('car_id', carId)
        .eq('activestatus', 1);

    return (response as List<dynamic>)
        .map((e) => ShoppingCartDetailModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching shopping cart details: $e');
    return [];
  }
});

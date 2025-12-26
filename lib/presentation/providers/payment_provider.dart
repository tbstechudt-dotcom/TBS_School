import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/payment_model.dart';
import '../../data/dummy_data.dart';
import 'auth_provider.dart';
import 'student_provider.dart';

final paymentsProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final student = ref.watch(selectedStudentProvider);

  if (student == null) return [];

  // Use dummy data for development/testing
  if (useDummyData) {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getPaymentsForStudent(student.id);
  }

  final client = ref.watch(supabaseClientProvider);

  final response = await client.from('payments').select('''
        *,
        payment_details (
          id,
          payment_id,
          student_fee_id,
          amount,
          student_fees (
            fee_types (
              name
            )
          )
        )
      ''').eq('student_id', student.id).order('created_at', ascending: false);

  return (response as List<dynamic>)
      .map((e) => PaymentModel.fromJson(e))
      .toList();
});

final paymentByIdProvider =
    FutureProvider.family<PaymentModel?, String>((ref, paymentId) async {
  final client = ref.watch(supabaseClientProvider);

  final response = await client.from('payments').select('''
        *,
        payment_details (
          id,
          payment_id,
          student_fee_id,
          amount,
          student_fees (
            fee_types (
              name
            )
          )
        )
      ''').eq('id', paymentId).maybeSingle();

  if (response == null) return null;
  return PaymentModel.fromJson(response);
});

final recentPaymentsProvider = Provider<List<PaymentModel>>((ref) {
  final paymentsAsync = ref.watch(paymentsProvider);
  return paymentsAsync.maybeWhen(
    data: (payments) => payments.take(5).toList(),
    orElse: () => [],
  );
});

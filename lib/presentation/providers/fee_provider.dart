import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fee_model.dart';
import '../../data/dummy_data.dart';
import 'auth_provider.dart';
import 'student_provider.dart';

final feesProvider = FutureProvider<List<FeeModel>>((ref) async {
  final student = ref.watch(selectedStudentProvider);

  if (student == null) return [];

  // Use dummy data for development/testing
  if (useDummyData) {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getFeesForStudent(student.id);
  }

  final client = ref.watch(supabaseClientProvider);

  final response = await client.from('student_fees').select('''
        *,
        fee_types (
          name,
          is_mandatory
        )
      ''').eq('student_id', student.id).order('due_date', ascending: true);

  return (response as List<dynamic>).map((e) => FeeModel.fromJson(e)).toList();
});

final pendingFeesProvider = Provider<List<FeeModel>>((ref) {
  final feesAsync = ref.watch(feesProvider);
  return feesAsync.maybeWhen(
    data: (fees) => fees
        .where((f) =>
            f.status == FeeStatus.pending || f.status == FeeStatus.overdue)
        .toList(),
    orElse: () => [],
  );
});

final feeSummaryProvider = FutureProvider<FeeSummary>((ref) async {
  final fees = await ref.watch(feesProvider.future);

  double totalDue = 0;
  double totalPaid = 0;
  double totalPending = 0;
  int pendingCount = 0;
  int overdueCount = 0;
  DateTime? nextDueDate;

  for (final fee in fees) {
    totalDue += fee.totalAmount;
    totalPaid += fee.paidAmount;
    totalPending += fee.balanceAmount;

    if (fee.status == FeeStatus.pending || fee.status == FeeStatus.partial) {
      pendingCount++;
      if (nextDueDate == null || fee.dueDate.isBefore(nextDueDate)) {
        nextDueDate = fee.dueDate;
      }
    }
    if (fee.status == FeeStatus.overdue) {
      overdueCount++;
    }
  }

  return FeeSummary(
    totalDue: totalDue,
    totalPaid: totalPaid,
    totalPending: totalPending,
    pendingCount: pendingCount,
    overdueCount: overdueCount,
    nextDueDate: nextDueDate,
  );
});

enum FeeStatus { pending, partial, paid, overdue }

class FeeModel {
  final String id;
  final String studentId;
  final String feeTypeId;
  final String feeTypeName;
  final String term;
  final double amount;
  final double discountAmount;
  final double lateFee;
  final double totalAmount;
  final double paidAmount;
  final double balanceAmount;
  final DateTime dueDate;
  final FeeStatus status;
  final bool isMandatory;

  FeeModel({
    required this.id,
    required this.studentId,
    required this.feeTypeId,
    required this.feeTypeName,
    required this.term,
    required this.amount,
    this.discountAmount = 0,
    this.lateFee = 0,
    required this.totalAmount,
    this.paidAmount = 0,
    required this.balanceAmount,
    required this.dueDate,
    required this.status,
    this.isMandatory = true,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      id: json['id'],
      studentId: json['student_id'],
      feeTypeId: json['fee_type_id'],
      feeTypeName: json['fee_types']?['name'] ?? '',
      term: json['term'],
      amount: (json['amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      lateFee: (json['late_fee'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0,
      balanceAmount: (json['balance_amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date']),
      status: _parseStatus(json['status']),
      isMandatory: json['fee_types']?['is_mandatory'] ?? true,
    );
  }

  static FeeStatus _parseStatus(String status) {
    switch (status) {
      case 'paid':
        return FeeStatus.paid;
      case 'partial':
        return FeeStatus.partial;
      case 'overdue':
        return FeeStatus.overdue;
      default:
        return FeeStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'fee_type_id': feeTypeId,
      'term': term,
      'amount': amount,
      'discount_amount': discountAmount,
      'late_fee': lateFee,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'balance_amount': balanceAmount,
      'due_date': dueDate.toIso8601String(),
      'status': status.name,
    };
  }
}

class FeeSummary {
  final double totalDue;
  final double totalPaid;
  final double totalPending;
  final int pendingCount;
  final int overdueCount;
  final DateTime? nextDueDate;

  FeeSummary({
    required this.totalDue,
    required this.totalPaid,
    required this.totalPending,
    required this.pendingCount,
    required this.overdueCount,
    this.nextDueDate,
  });
}

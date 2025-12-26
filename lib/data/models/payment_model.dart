enum PaymentStatus { pending, success, failed, refunded }

class PaymentModel {
  final String id;
  final String paymentNumber;
  final String studentId;
  final String parentId;
  final double amount;
  final String? paymentMethod;
  final String? transactionId;
  final PaymentStatus status;
  final DateTime? paidAt;
  final String? receiptUrl;
  final String? notes;
  final DateTime createdAt;
  final List<PaymentDetailModel> details;

  PaymentModel({
    required this.id,
    required this.paymentNumber,
    required this.studentId,
    required this.parentId,
    required this.amount,
    this.paymentMethod,
    this.transactionId,
    required this.status,
    this.paidAt,
    this.receiptUrl,
    this.notes,
    required this.createdAt,
    this.details = const [],
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      paymentNumber: json['payment_number'],
      studentId: json['student_id'],
      parentId: json['parent_id'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      transactionId: json['transaction_id'],
      status: _parseStatus(json['status']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      receiptUrl: json['receipt_url'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      details: (json['payment_details'] as List<dynamic>?)
              ?.map((e) => PaymentDetailModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status) {
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_number': paymentNumber,
      'student_id': studentId,
      'parent_id': parentId,
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'status': status.name,
      'paid_at': paidAt?.toIso8601String(),
      'receipt_url': receiptUrl,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PaymentDetailModel {
  final String id;
  final String paymentId;
  final String studentFeeId;
  final double amount;
  final String? feeName;

  PaymentDetailModel({
    required this.id,
    required this.paymentId,
    required this.studentFeeId,
    required this.amount,
    this.feeName,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      id: json['id'],
      paymentId: json['payment_id'],
      studentFeeId: json['student_fee_id'],
      amount: (json['amount'] as num).toDouble(),
      feeName: json['student_fees']?['fee_types']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_id': paymentId,
      'student_fee_id': studentFeeId,
      'amount': amount,
    };
  }
}

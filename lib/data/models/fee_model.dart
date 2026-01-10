/// Fee status based on paidstatus field ('P' = Paid, 'U' = Unpaid)
enum FeeStatus { pending, partial, paid, overdue }

/// Fee demand model matching Supabase 'feedemand' table
class FeeModel {
  final int demId;
  final String demno;
  final int insId;
  final String inscode;
  final int yrId;
  final String demseqtype; // Sequence type for fee demand
  final int stuId;
  final String stuadmno;
  final String stuclass;
  final String demfeeyear;
  final String demfeeterm;
  final String demfeetype;
  final String? demfeecategory;
  final double feeamount;
  final int conId;
  final double conamount;
  final double paidamount;
  final double balancedue;
  final int? payId;
  final String paidstatus;
  final String createdby;
  final DateTime createdat;
  final int activestatus;
  final DateTime? inactivedate;
  final DateTime? duedate;

  FeeModel({
    required this.demId,
    required this.demno,
    required this.insId,
    required this.inscode,
    required this.yrId,
    required this.demseqtype,
    required this.stuId,
    required this.stuadmno,
    required this.stuclass,
    required this.demfeeyear,
    required this.demfeeterm,
    required this.demfeetype,
    this.demfeecategory,
    required this.feeamount,
    required this.conId,
    this.conamount = 0,
    this.paidamount = 0,
    required this.balancedue,
    this.payId,
    required this.paidstatus,
    required this.createdby,
    required this.createdat,
    this.activestatus = 1,
    this.inactivedate,
    this.duedate,
  });

  /// Create from Supabase JSON response
  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      demId: json['dem_id'] is int ? json['dem_id'] : int.parse(json['dem_id'].toString()),
      demno: json['demno'] ?? '',
      insId: json['ins_id'] is int ? json['ins_id'] : int.parse(json['ins_id'].toString()),
      inscode: json['inscode'] ?? '',
      yrId: json['yr_id'] is int ? json['yr_id'] : int.parse(json['yr_id'].toString()),
      demseqtype: json['demseqtype'] ?? '',
      stuId: json['stu_id'] is int ? json['stu_id'] : int.parse(json['stu_id'].toString()),
      stuadmno: json['stuadmno'] ?? '',
      stuclass: json['stuclass'] ?? '',
      demfeeyear: json['demfeeyear'] ?? '',
      demfeeterm: json['demfeeterm'] ?? '',
      demfeetype: json['demfeetype'] ?? '',
      demfeecategory: json['demfeecategory'],
      feeamount: (json['feeamount'] as num?)?.toDouble() ?? 0,
      conId: json['con_id'] is int ? json['con_id'] : int.parse(json['con_id'].toString()),
      conamount: (json['conamount'] as num?)?.toDouble() ?? 0,
      paidamount: (json['paidamount'] as num?)?.toDouble() ?? 0,
      balancedue: (json['balancedue'] as num?)?.toDouble() ?? 0,
      payId: json['pay_id'] != null
          ? (json['pay_id'] is int ? json['pay_id'] : int.parse(json['pay_id'].toString()))
          : null,
      paidstatus: json['paidstatus'] ?? 'U',
      createdby: json['createdby'] ?? '',
      createdat: json['createdat'] != null
          ? DateTime.parse(json['createdat'])
          : DateTime.now(),
      activestatus: json['activestatus'] ?? 1,
      inactivedate: json['inactivedate'] != null
          ? DateTime.parse(json['inactivedate'])
          : null,
      duedate: json['duedate'] != null
          ? DateTime.parse(json['duedate'])
          : null,
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'dem_id': demId,
      'demno': demno,
      'ins_id': insId,
      'inscode': inscode,
      'yr_id': yrId,
      'demseqtype': demseqtype,
      'stu_id': stuId,
      'stuadmno': stuadmno,
      'stuclass': stuclass,
      'demfeeyear': demfeeyear,
      'demfeeterm': demfeeterm,
      'demfeetype': demfeetype,
      'demfeecategory': demfeecategory,
      'feeamount': feeamount,
      'con_id': conId,
      'conamount': conamount,
      'paidamount': paidamount,
      'balancedue': balancedue,
      'pay_id': payId,
      'paidstatus': paidstatus,
      'createdby': createdby,
      'activestatus': activestatus,
    };
  }

  /// Helper getters for UI display (backward compatible with old model)
  String get id => demId.toString();
  String get feeTypeName => demfeetype;
  String get term => '$demfeeterm ($demfeeyear)';
  double get amount => feeamount;
  double get discountAmount => conamount;
  double get totalAmount => feeamount - conamount;
  double get balanceAmount => balancedue;
  double get paidAmount => paidamount;

  /// Late fee - not in feedemand table, returns 0
  double get lateFee => 0;

  /// Due date - from duedate column, falls back to createdat if null
  DateTime get dueDate => duedate ?? createdat;

  FeeStatus get status {
    if (paidstatus == 'P') return FeeStatus.paid;
    if (paidamount > 0 && balancedue > 0) return FeeStatus.partial;
    return FeeStatus.pending;
  }

  bool get isPaid => paidstatus == 'P';
  bool get isActive => activestatus == 1;

  FeeModel copyWith({
    int? demId,
    String? demno,
    int? insId,
    String? inscode,
    int? yrId,
    String? demseqtype,
    int? stuId,
    String? stuadmno,
    String? stuclass,
    String? demfeeyear,
    String? demfeeterm,
    String? demfeetype,
    String? demfeecategory,
    double? feeamount,
    int? conId,
    double? conamount,
    double? paidamount,
    double? balancedue,
    int? payId,
    String? paidstatus,
    String? createdby,
    DateTime? createdat,
    int? activestatus,
    DateTime? inactivedate,
    DateTime? duedate,
  }) {
    return FeeModel(
      demId: demId ?? this.demId,
      demno: demno ?? this.demno,
      insId: insId ?? this.insId,
      inscode: inscode ?? this.inscode,
      yrId: yrId ?? this.yrId,
      demseqtype: demseqtype ?? this.demseqtype,
      stuId: stuId ?? this.stuId,
      stuadmno: stuadmno ?? this.stuadmno,
      stuclass: stuclass ?? this.stuclass,
      demfeeyear: demfeeyear ?? this.demfeeyear,
      demfeeterm: demfeeterm ?? this.demfeeterm,
      demfeetype: demfeetype ?? this.demfeetype,
      demfeecategory: demfeecategory ?? this.demfeecategory,
      feeamount: feeamount ?? this.feeamount,
      conId: conId ?? this.conId,
      conamount: conamount ?? this.conamount,
      paidamount: paidamount ?? this.paidamount,
      balancedue: balancedue ?? this.balancedue,
      payId: payId ?? this.payId,
      paidstatus: paidstatus ?? this.paidstatus,
      createdby: createdby ?? this.createdby,
      createdat: createdat ?? this.createdat,
      activestatus: activestatus ?? this.activestatus,
      inactivedate: inactivedate ?? this.inactivedate,
      duedate: duedate ?? this.duedate,
    );
  }
}

/// Fee summary for dashboard display
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

/// Payment status based on paystatus field
/// 'I' = Initiated, 'C' = Complete, 'F' = Failed, 'R' = Refunded
enum PaymentStatus { pending, success, failed, refunded }

/// Payment model matching Supabase 'payment' table
class PaymentModel {
  final int payId;
  final int insId;
  final String? inscode;
  final int? carId;
  final DateTime? paydate;
  final String? paystatus;
  final String? paymethod;
  final String? payreference;
  final int? paygwresponse;
  final DateTime createdat;
  final int activestatus;

  PaymentModel({
    required this.payId,
    required this.insId,
    this.inscode,
    this.carId,
    this.paydate,
    this.paystatus,
    this.paymethod,
    this.payreference,
    this.paygwresponse,
    required this.createdat,
    this.activestatus = 1,
  });

  /// Create from Supabase JSON response
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      payId: json['pay_id'] is int ? json['pay_id'] : int.parse(json['pay_id'].toString()),
      insId: json['ins_id'] is int ? json['ins_id'] : int.parse(json['ins_id'].toString()),
      inscode: json['inscode'],
      carId: json['car_id'] != null
          ? (json['car_id'] is int ? json['car_id'] : int.parse(json['car_id'].toString()))
          : null,
      paydate: json['paydate'] != null ? DateTime.parse(json['paydate']) : null,
      paystatus: json['paystatus'],
      paymethod: json['paymethod'],
      payreference: json['payreference'],
      paygwresponse: json['paygwresponse'] != null
          ? (json['paygwresponse'] is int ? json['paygwresponse'] : int.parse(json['paygwresponse'].toString()))
          : null,
      createdat: json['createdat'] != null
          ? DateTime.parse(json['createdat'])
          : DateTime.now(),
      activestatus: json['activestatus'] ?? 1,
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'pay_id': payId,
      'ins_id': insId,
      'inscode': inscode,
      'car_id': carId,
      'paydate': paydate?.toIso8601String(),
      'paystatus': paystatus,
      'paymethod': paymethod,
      'payreference': payreference,
      'paygwresponse': paygwresponse,
      'activestatus': activestatus,
    };
  }

  /// Helper getters for UI display (backward compatible with old model)
  String get id => payId.toString();
  String get paymentNumber => 'PAY${payId.toString().padLeft(6, '0')}';
  DateTime get createdAt => createdat;

  /// Amount - not directly in payment table, would need to join with shoppingcart
  /// Returns 0 as placeholder - actual amount should come from cart
  double get amount => 0;

  /// Details - empty list as placeholder, would need to fetch from shoppingcartdetails
  List<dynamic> get details => [];

  PaymentStatus get status {
    switch (paystatus) {
      case 'C':
        return PaymentStatus.success;
      case 'F':
        return PaymentStatus.failed;
      case 'R':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  String get statusText {
    switch (paystatus) {
      case 'C':
        return 'Completed';
      case 'F':
        return 'Failed';
      case 'R':
        return 'Refunded';
      case 'I':
        return 'Initiated';
      default:
        return 'Pending';
    }
  }

  String get paymentMethod => paymethod ?? 'Unknown';
  String get transactionId => payreference ?? '';
  DateTime? get paidAt => paydate;
  bool get isActive => activestatus == 1;
  bool get isSuccess => paystatus == 'C';

  PaymentModel copyWith({
    int? payId,
    int? insId,
    String? inscode,
    int? carId,
    DateTime? paydate,
    String? paystatus,
    String? paymethod,
    String? payreference,
    int? paygwresponse,
    DateTime? createdat,
    int? activestatus,
  }) {
    return PaymentModel(
      payId: payId ?? this.payId,
      insId: insId ?? this.insId,
      inscode: inscode ?? this.inscode,
      carId: carId ?? this.carId,
      paydate: paydate ?? this.paydate,
      paystatus: paystatus ?? this.paystatus,
      paymethod: paymethod ?? this.paymethod,
      payreference: payreference ?? this.payreference,
      paygwresponse: paygwresponse ?? this.paygwresponse,
      createdat: createdat ?? this.createdat,
      activestatus: activestatus ?? this.activestatus,
    );
  }
}

/// Shopping cart model matching Supabase 'shoppingcart' table
class ShoppingCartModel {
  final int carId;
  final int insId;
  final String transtype;
  final DateTime transdate;
  final String transcurrency;
  final double transtotalamount;
  final String carinitiated;
  final int? payId;
  final String createdby;
  final DateTime createdon;
  final int activestatus;

  ShoppingCartModel({
    required this.carId,
    required this.insId,
    required this.transtype,
    required this.transdate,
    required this.transcurrency,
    required this.transtotalamount,
    required this.carinitiated,
    this.payId,
    required this.createdby,
    required this.createdon,
    this.activestatus = 1,
  });

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartModel(
      carId: json['car_id'] is int ? json['car_id'] : int.parse(json['car_id'].toString()),
      insId: json['ins_id'] is int ? json['ins_id'] : int.parse(json['ins_id'].toString()),
      transtype: json['transtype'] ?? '',
      transdate: json['transdate'] != null
          ? DateTime.parse(json['transdate'])
          : DateTime.now(),
      transcurrency: json['transcurrency'] ?? 'INR',
      transtotalamount: (json['transtotalamount'] as num?)?.toDouble() ?? 0,
      carinitiated: json['carinitiated'] ?? 'N',
      payId: json['pay_id'] != null
          ? (json['pay_id'] is int ? json['pay_id'] : int.parse(json['pay_id'].toString()))
          : null,
      createdby: json['createdby'] ?? '',
      createdon: json['createdon'] != null
          ? DateTime.parse(json['createdon'])
          : DateTime.now(),
      activestatus: json['activestatus'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'ins_id': insId,
      'transtype': transtype,
      'transdate': transdate.toIso8601String().split('T')[0],
      'transcurrency': transcurrency,
      'transtotalamount': transtotalamount,
      'carinitiated': carinitiated,
      'pay_id': payId,
      'createdby': createdby,
      'activestatus': activestatus,
    };
  }

  double get amount => transtotalamount;
  String get currency => transcurrency;
  bool get isActive => activestatus == 1;
}

/// Shopping cart details model matching Supabase 'shoppingcartdetails' table
class ShoppingCartDetailModel {
  final int cdId;
  final int carId;
  final int insId;
  final int? transdetailId;
  final String transcurrency;
  final double transtotalamount;
  final int activestatus;

  ShoppingCartDetailModel({
    required this.cdId,
    required this.carId,
    required this.insId,
    this.transdetailId,
    required this.transcurrency,
    required this.transtotalamount,
    this.activestatus = 1,
  });

  factory ShoppingCartDetailModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartDetailModel(
      cdId: json['cd_id'] is int ? json['cd_id'] : int.parse(json['cd_id'].toString()),
      carId: json['car_id'] is int ? json['car_id'] : int.parse(json['car_id'].toString()),
      insId: json['ins_id'] is int ? json['ins_id'] : int.parse(json['ins_id'].toString()),
      transdetailId: json['transdetail_id'] != null
          ? (json['transdetail_id'] is int ? json['transdetail_id'] : int.parse(json['transdetail_id'].toString()))
          : null,
      transcurrency: json['transcurrency'] ?? 'INR',
      transtotalamount: (json['transtotalamount'] as num?)?.toDouble() ?? 0,
      activestatus: json['activestatus'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cd_id': cdId,
      'car_id': carId,
      'ins_id': insId,
      'transdetail_id': transdetailId,
      'transcurrency': transcurrency,
      'transtotalamount': transtotalamount,
      'activestatus': activestatus,
    };
  }

  double get amount => transtotalamount;
  bool get isActive => activestatus == 1;
}

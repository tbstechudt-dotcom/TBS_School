/// Student model matching Supabase 'students' table
class StudentModel {
  final int stuId;
  final int insId;
  final String inscode;
  final int parId; // Parent ID - links to parents table
  final String stuadmno;
  final DateTime stuadmdate;
  final String stuname;
  final String stugender;
  final DateTime studob;
  final String stumobile;
  final String? stuemail;
  final String? stuaddress1;
  final String? stuaddress2;
  final String? stuaddress3;
  final String? stucity;
  final String? stustate;
  final String? stucountry;
  final String? stupin;
  final String? stugeocoordinates;
  final String? stubloodgrp;
  final String? stuphoto;
  final String stuclass;
  final String stuserId;
  final int stuotpstatus;
  final int activestatus;
  final DateTime createdon;

  StudentModel({
    required this.stuId,
    required this.insId,
    required this.inscode,
    required this.parId,
    required this.stuadmno,
    required this.stuadmdate,
    required this.stuname,
    required this.stugender,
    required this.studob,
    required this.stumobile,
    this.stuemail,
    this.stuaddress1,
    this.stuaddress2,
    this.stuaddress3,
    this.stucity,
    this.stustate,
    this.stucountry,
    this.stupin,
    this.stugeocoordinates,
    this.stubloodgrp,
    this.stuphoto,
    required this.stuclass,
    required this.stuserId,
    this.stuotpstatus = 0,
    this.activestatus = 1,
    required this.createdon,
  });

  /// Create from Supabase JSON response
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      stuId: json['stu_id'] is int ? json['stu_id'] : int.parse(json['stu_id'].toString()),
      insId: json['ins_id'] is int ? json['ins_id'] : int.parse(json['ins_id'].toString()),
      inscode: json['inscode'] ?? '',
      parId: json['par_id'] is int ? json['par_id'] : int.parse(json['par_id'].toString()),
      stuadmno: json['stuadmno'] ?? '',
      stuadmdate: json['stuadmdate'] != null
          ? DateTime.parse(json['stuadmdate'])
          : DateTime.now(),
      stuname: json['stuname'] ?? '',
      stugender: json['stugender'] ?? 'M',
      studob: json['studob'] != null
          ? DateTime.parse(json['studob'])
          : DateTime.now(),
      stumobile: json['stumobile'] ?? '',
      stuemail: json['stuemail'],
      stuaddress1: json['stuaddress1'],
      stuaddress2: json['stuaddress2'],
      stuaddress3: json['stuaddress3'],
      stucity: json['stucity'],
      stustate: json['stustate'],
      stucountry: json['stucountry'],
      stupin: json['stupin'],
      stugeocoordinates: json['stugeocoordinates'],
      stubloodgrp: json['stubloodgrp'],
      stuphoto: json['stuphoto'],
      stuclass: json['stuclass'] ?? '',
      stuserId: json['stuser_id'] ?? '',
      stuotpstatus: json['stuotpstatus'] ?? 0,
      activestatus: json['activestatus'] ?? 1,
      createdon: json['createdon'] != null
          ? DateTime.parse(json['createdon'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'stu_id': stuId,
      'ins_id': insId,
      'inscode': inscode,
      'par_id': parId,
      'stuadmno': stuadmno,
      'stuadmdate': stuadmdate.toIso8601String().split('T')[0],
      'stuname': stuname,
      'stugender': stugender,
      'studob': studob.toIso8601String().split('T')[0],
      'stumobile': stumobile,
      'stuemail': stuemail,
      'stuaddress1': stuaddress1,
      'stuaddress2': stuaddress2,
      'stuaddress3': stuaddress3,
      'stucity': stucity,
      'stustate': stustate,
      'stucountry': stucountry,
      'stupin': stupin,
      'stugeocoordinates': stugeocoordinates,
      'stubloodgrp': stubloodgrp,
      'stuphoto': stuphoto,
      'stuclass': stuclass,
      'stuser_id': stuserId,
      'stuotpstatus': stuotpstatus,
      'activestatus': activestatus,
    };
  }

  /// Helper getters for UI display (backward compatible with old model)
  String get name => stuname;
  String get displayName => stuname;
  String get admissionNumber => stuadmno;
  String get className => stuclass;
  String get gender => stugender == 'M' ? 'Male' : stugender == 'F' ? 'Female' : 'Other';
  String get mobile => stumobile;
  String? get email => stuemail;
  String? get photoUrl => stuphoto;
  bool get isActive => activestatus == 1;
  DateTime get dateOfBirth => studob;

  String get fullAddress {
    final parts = [stuaddress1, stuaddress2, stuaddress3, stucity, stustate, stucountry, stupin]
        .where((p) => p != null && p.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  StudentModel copyWith({
    int? stuId,
    int? insId,
    String? inscode,
    int? parId,
    String? stuadmno,
    DateTime? stuadmdate,
    String? stuname,
    String? stugender,
    DateTime? studob,
    String? stumobile,
    String? stuemail,
    String? stuaddress1,
    String? stuaddress2,
    String? stuaddress3,
    String? stucity,
    String? stustate,
    String? stucountry,
    String? stupin,
    String? stugeocoordinates,
    String? stubloodgrp,
    String? stuphoto,
    String? stuclass,
    String? stuserId,
    int? stuotpstatus,
    int? activestatus,
    DateTime? createdon,
  }) {
    return StudentModel(
      stuId: stuId ?? this.stuId,
      insId: insId ?? this.insId,
      inscode: inscode ?? this.inscode,
      parId: parId ?? this.parId,
      stuadmno: stuadmno ?? this.stuadmno,
      stuadmdate: stuadmdate ?? this.stuadmdate,
      stuname: stuname ?? this.stuname,
      stugender: stugender ?? this.stugender,
      studob: studob ?? this.studob,
      stumobile: stumobile ?? this.stumobile,
      stuemail: stuemail ?? this.stuemail,
      stuaddress1: stuaddress1 ?? this.stuaddress1,
      stuaddress2: stuaddress2 ?? this.stuaddress2,
      stuaddress3: stuaddress3 ?? this.stuaddress3,
      stucity: stucity ?? this.stucity,
      stustate: stustate ?? this.stustate,
      stucountry: stucountry ?? this.stucountry,
      stupin: stupin ?? this.stupin,
      stugeocoordinates: stugeocoordinates ?? this.stugeocoordinates,
      stubloodgrp: stubloodgrp ?? this.stubloodgrp,
      stuphoto: stuphoto ?? this.stuphoto,
      stuclass: stuclass ?? this.stuclass,
      stuserId: stuserId ?? this.stuserId,
      stuotpstatus: stuotpstatus ?? this.stuotpstatus,
      activestatus: activestatus ?? this.activestatus,
      createdon: createdon ?? this.createdon,
    );
  }
}

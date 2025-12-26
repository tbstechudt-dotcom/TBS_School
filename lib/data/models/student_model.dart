class StudentModel {
  final String id;
  final String schoolId;
  final String classId;
  final String admissionNumber;
  final String name;
  final String? className;
  final String? section;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? photoUrl;
  final bool isActive;

  StudentModel({
    required this.id,
    required this.schoolId,
    required this.classId,
    required this.admissionNumber,
    required this.name,
    this.className,
    this.section,
    this.dateOfBirth,
    this.gender,
    this.photoUrl,
    this.isActive = true,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      schoolId: json['school_id'],
      classId: json['class_id'],
      admissionNumber: json['admission_number'],
      name: json['name'],
      className: json['classes']?['name'],
      section: json['classes']?['section'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      photoUrl: json['photo_url'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'class_id': classId,
      'admission_number': admissionNumber,
      'name': name,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'photo_url': photoUrl,
      'is_active': isActive,
    };
  }

  StudentModel copyWith({
    String? id,
    String? schoolId,
    String? classId,
    String? admissionNumber,
    String? name,
    String? className,
    String? section,
    DateTime? dateOfBirth,
    String? gender,
    String? photoUrl,
    bool? isActive,
  }) {
    return StudentModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      classId: classId ?? this.classId,
      admissionNumber: admissionNumber ?? this.admissionNumber,
      name: name ?? this.name,
      className: className ?? this.className,
      section: section ?? this.section,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}

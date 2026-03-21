enum NotificationType {
  feeReminder,
  paymentSuccess,
  paymentFailed,
  dueDateApproaching,
  newFeeAdded,
  general,
  announcement,
  alert,
}

class NotificationModel {
  final String id;
  final String schoolId;
  final String parentId;
  final String? studentId;
  final String title;
  final String message;
  final NotificationType type;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.schoolId,
    required this.parentId,
    this.studentId,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  /// Alias for message property for compatibility
  String get body => message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      schoolId: json['school_id'],
      parentId: json['parent_id'],
      studentId: json['student_id'],
      title: json['title'],
      message: json['message'],
      type: _parseType(json['type']),
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? _parseLocalDateTime(json['read_at']) : null,
      createdAt: _parseLocalDateTime(json['created_at']),
    );
  }

  /// Parses a PostgreSQL timestamptz string and extracts the local time
  /// directly from the offset, avoiding Flutter web's broken toLocal().
  /// e.g. "2026-03-21 15:37:19.813237+0530" → DateTime(2026,3,21,15,37,19)
  static DateTime _parseLocalDateTime(String raw) {
    final parsed = DateTime.parse(raw);
    // Match timezone offset like +0530, +05:30, +05, -0800, etc.
    final offsetMatch = RegExp(r'([+-])(\d{2}):?(\d{2})?$').firstMatch(raw);
    if (offsetMatch != null) {
      final sign = offsetMatch.group(1) == '+' ? 1 : -1;
      final hours = int.parse(offsetMatch.group(2)!);
      final minutes = int.parse(offsetMatch.group(3) ?? '0');
      final offset = Duration(hours: hours, minutes: minutes) * sign;
      // parsed is in UTC; add the offset to get the original local time
      final localTime = parsed.add(offset);
      return DateTime(localTime.year, localTime.month, localTime.day,
          localTime.hour, localTime.minute, localTime.second, localTime.millisecond);
    }
    // No offset found — treat as local time
    return parsed;
  }

  static NotificationType _parseType(String? type) {
    switch (type) {
      case 'fee_reminder':
        return NotificationType.feeReminder;
      case 'payment_success':
        return NotificationType.paymentSuccess;
      case 'payment_failed':
        return NotificationType.paymentFailed;
      case 'due_date_approaching':
        return NotificationType.dueDateApproaching;
      case 'new_fee_added':
        return NotificationType.newFeeAdded;
      case 'announcement':
        return NotificationType.announcement;
      case 'alert':
        return NotificationType.alert;
      case 'general':
      default:
        return NotificationType.general;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'parent_id': parentId,
      'student_id': studentId,
      'title': title,
      'message': message,
      'type': type.name,
      'data': data,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? schoolId,
    String? parentId,
    String? studentId,
    String? title,
    String? message,
    NotificationType? type,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      parentId: parentId ?? this.parentId,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

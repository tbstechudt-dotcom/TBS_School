import 'models/student_model.dart';
import 'models/fee_model.dart';
import 'models/payment_model.dart';
import 'models/notification_model.dart';

/// Dummy data for testing and development
class DummyData {
  DummyData._();

  // Dummy Students
  static final List<StudentModel> students = [
    StudentModel(
      id: 'student-001',
      schoolId: 'school-001',
      classId: 'class-001',
      admissionNumber: 'TBS2024001',
      name: 'Aarav Sharma',
      className: 'Class 10',
      section: 'A',
      dateOfBirth: DateTime(2010, 5, 15),
      gender: 'Male',
      photoUrl: null,
      isActive: true,
    ),
    StudentModel(
      id: 'student-002',
      schoolId: 'school-001',
      classId: 'class-002',
      admissionNumber: 'TBS2024002',
      name: 'Ananya Sharma',
      className: 'Class 7',
      section: 'B',
      dateOfBirth: DateTime(2013, 8, 22),
      gender: 'Female',
      photoUrl: null,
      isActive: true,
    ),
  ];

  // Dummy Fees for student-001
  static List<FeeModel> getFeesForStudent(String studentId) {
    if (studentId == 'student-001') {
      return [
        FeeModel(
          id: 'fee-001',
          studentId: 'student-001',
          feeTypeId: 'feetype-001',
          feeTypeName: 'Tuition Fee',
          term: 'Term 1 (2024-25)',
          amount: 25000,
          discountAmount: 2500,
          lateFee: 0,
          totalAmount: 22500,
          paidAmount: 22500,
          balanceAmount: 0,
          dueDate: DateTime(2024, 6, 30),
          status: FeeStatus.paid,
          isMandatory: true,
        ),
        FeeModel(
          id: 'fee-002',
          studentId: 'student-001',
          feeTypeId: 'feetype-001',
          feeTypeName: 'Tuition Fee',
          term: 'Term 2 (2024-25)',
          amount: 25000,
          discountAmount: 2500,
          lateFee: 0,
          totalAmount: 22500,
          paidAmount: 10000,
          balanceAmount: 12500,
          dueDate: DateTime(2024, 12, 31),
          status: FeeStatus.partial,
          isMandatory: true,
        ),
        FeeModel(
          id: 'fee-003',
          studentId: 'student-001',
          feeTypeId: 'feetype-002',
          feeTypeName: 'Lab Fee',
          term: 'Term 2 (2024-25)',
          amount: 5000,
          discountAmount: 0,
          lateFee: 0,
          totalAmount: 5000,
          paidAmount: 0,
          balanceAmount: 5000,
          dueDate: DateTime(2025, 1, 15),
          status: FeeStatus.pending,
          isMandatory: true,
        ),
        FeeModel(
          id: 'fee-004',
          studentId: 'student-001',
          feeTypeId: 'feetype-003',
          feeTypeName: 'Sports Fee',
          term: 'Annual (2024-25)',
          amount: 3000,
          discountAmount: 0,
          lateFee: 500,
          totalAmount: 3500,
          paidAmount: 0,
          balanceAmount: 3500,
          dueDate: DateTime(2024, 11, 30),
          status: FeeStatus.overdue,
          isMandatory: false,
        ),
        FeeModel(
          id: 'fee-005',
          studentId: 'student-001',
          feeTypeId: 'feetype-004',
          feeTypeName: 'Computer Fee',
          term: 'Term 2 (2024-25)',
          amount: 4000,
          discountAmount: 0,
          lateFee: 0,
          totalAmount: 4000,
          paidAmount: 0,
          balanceAmount: 4000,
          dueDate: DateTime(2025, 2, 28),
          status: FeeStatus.pending,
          isMandatory: true,
        ),
      ];
    } else if (studentId == 'student-002') {
      return [
        FeeModel(
          id: 'fee-101',
          studentId: 'student-002',
          feeTypeId: 'feetype-001',
          feeTypeName: 'Tuition Fee',
          term: 'Term 1 (2024-25)',
          amount: 20000,
          discountAmount: 2000,
          lateFee: 0,
          totalAmount: 18000,
          paidAmount: 18000,
          balanceAmount: 0,
          dueDate: DateTime(2024, 6, 30),
          status: FeeStatus.paid,
          isMandatory: true,
        ),
        FeeModel(
          id: 'fee-102',
          studentId: 'student-002',
          feeTypeId: 'feetype-001',
          feeTypeName: 'Tuition Fee',
          term: 'Term 2 (2024-25)',
          amount: 20000,
          discountAmount: 2000,
          lateFee: 0,
          totalAmount: 18000,
          paidAmount: 0,
          balanceAmount: 18000,
          dueDate: DateTime(2025, 1, 10),
          status: FeeStatus.pending,
          isMandatory: true,
        ),
        FeeModel(
          id: 'fee-103',
          studentId: 'student-002',
          feeTypeId: 'feetype-005',
          feeTypeName: 'Library Fee',
          term: 'Annual (2024-25)',
          amount: 1500,
          discountAmount: 0,
          lateFee: 0,
          totalAmount: 1500,
          paidAmount: 1500,
          balanceAmount: 0,
          dueDate: DateTime(2024, 7, 31),
          status: FeeStatus.paid,
          isMandatory: true,
        ),
      ];
    }
    return [];
  }

  // Dummy Payments for student-001
  static List<PaymentModel> getPaymentsForStudent(String studentId) {
    if (studentId == 'student-001') {
      return [
        PaymentModel(
          id: 'payment-001',
          paymentNumber: 'PAY2024001001',
          studentId: 'student-001',
          parentId: 'parent-001',
          amount: 22500,
          paymentMethod: 'UPI',
          transactionId: 'TXN123456789',
          status: PaymentStatus.success,
          paidAt: DateTime(2024, 6, 25, 10, 30),
          receiptUrl: null,
          notes: 'Term 1 Tuition Fee Payment',
          createdAt: DateTime(2024, 6, 25, 10, 30),
          details: [
            PaymentDetailModel(
              id: 'pd-001',
              paymentId: 'payment-001',
              studentFeeId: 'fee-001',
              amount: 22500,
              feeName: 'Tuition Fee',
            ),
          ],
        ),
        PaymentModel(
          id: 'payment-002',
          paymentNumber: 'PAY2024001002',
          studentId: 'student-001',
          parentId: 'parent-001',
          amount: 10000,
          paymentMethod: 'Net Banking',
          transactionId: 'TXN987654321',
          status: PaymentStatus.success,
          paidAt: DateTime(2024, 10, 15, 14, 45),
          receiptUrl: null,
          notes: 'Partial payment for Term 2',
          createdAt: DateTime(2024, 10, 15, 14, 45),
          details: [
            PaymentDetailModel(
              id: 'pd-002',
              paymentId: 'payment-002',
              studentFeeId: 'fee-002',
              amount: 10000,
              feeName: 'Tuition Fee',
            ),
          ],
        ),
        PaymentModel(
          id: 'payment-003',
          paymentNumber: 'PAY2024001003',
          studentId: 'student-001',
          parentId: 'parent-001',
          amount: 5000,
          paymentMethod: 'Credit Card',
          transactionId: null,
          status: PaymentStatus.failed,
          paidAt: null,
          receiptUrl: null,
          notes: 'Payment failed - Card declined',
          createdAt: DateTime(2024, 12, 10, 9, 15),
          details: [],
        ),
      ];
    } else if (studentId == 'student-002') {
      return [
        PaymentModel(
          id: 'payment-101',
          paymentNumber: 'PAY2024002001',
          studentId: 'student-002',
          parentId: 'parent-001',
          amount: 19500,
          paymentMethod: 'UPI',
          transactionId: 'TXN555666777',
          status: PaymentStatus.success,
          paidAt: DateTime(2024, 6, 28, 11, 20),
          receiptUrl: null,
          notes: 'Term 1 Tuition + Library Fee',
          createdAt: DateTime(2024, 6, 28, 11, 20),
          details: [
            PaymentDetailModel(
              id: 'pd-101',
              paymentId: 'payment-101',
              studentFeeId: 'fee-101',
              amount: 18000,
              feeName: 'Tuition Fee',
            ),
            PaymentDetailModel(
              id: 'pd-102',
              paymentId: 'payment-101',
              studentFeeId: 'fee-103',
              amount: 1500,
              feeName: 'Library Fee',
            ),
          ],
        ),
      ];
    }
    return [];
  }

  // Dummy Notifications
  static List<NotificationModel> getNotifications() {
    return [
      NotificationModel(
        id: 'notif-001',
        schoolId: 'school-001',
        parentId: 'parent-001',
        studentId: 'student-001',
        title: 'Fee Payment Reminder',
        message: 'Sports Fee of Rs. 3,500 is overdue. Please pay immediately to avoid further late charges.',
        type: NotificationType.feeReminder,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 'notif-002',
        schoolId: 'school-001',
        parentId: 'parent-001',
        studentId: 'student-001',
        title: 'Payment Successful',
        message: 'Payment of Rs. 10,000 received for Term 2 Tuition Fee. Thank you!',
        type: NotificationType.paymentSuccess,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif-003',
        schoolId: 'school-001',
        parentId: 'parent-001',
        studentId: 'student-002',
        title: 'Due Date Approaching',
        message: 'Term 2 Tuition Fee of Rs. 18,000 for Ananya is due on 10th January 2025.',
        type: NotificationType.dueDateApproaching,
        isRead: true,
        readAt: DateTime.now().subtract(const Duration(hours: 12)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: 'notif-004',
        schoolId: 'school-001',
        parentId: 'parent-001',
        studentId: null,
        title: 'School Announcement',
        message: 'Winter vacation from 25th December to 5th January. School reopens on 6th January 2025.',
        type: NotificationType.announcement,
        isRead: true,
        readAt: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      NotificationModel(
        id: 'notif-005',
        schoolId: 'school-001',
        parentId: 'parent-001',
        studentId: 'student-001',
        title: 'New Fee Added',
        message: 'Computer Fee of Rs. 4,000 has been added for Term 2 (2024-25). Due date: 28th February 2025.',
        type: NotificationType.newFeeAdded,
        isRead: true,
        readAt: DateTime.now().subtract(const Duration(days: 6)),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}

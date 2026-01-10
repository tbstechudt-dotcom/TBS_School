/// BulkSMSGateway.in SMS configuration
class SmsConfig {
  SmsConfig._();

  /// API Base URL
  static const String apiUrl = 'http://api.bulksmsgateway.in/sendmessage.php';

  /// User email for authentication
  static const String user = 'tbsindiaudt@gmail.com';

  /// Password for authentication
  static const String password = 'TBSSms@123';

  /// Sender ID
  static const String senderId = 'TBSTEC';

  /// Template ID for OTP messages
  static const String otpTemplateId = '1407161157481665461';

  /// Message type (3 for Unicode)
  static const String messageType = '3';

  /// Check if SMS is properly configured
  static bool get isConfigured =>
      user.isNotEmpty && password.isNotEmpty && senderId.isNotEmpty;
}

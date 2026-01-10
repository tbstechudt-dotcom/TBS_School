import 'package:twilio_flutter/twilio_flutter.dart';
import '../../config/twilio_config.dart';

/// Service for sending SMS messages via Twilio
class SmsService {
  static TwilioFlutter? _twilioFlutter;

  /// Initialize the Twilio client
  static void initialize() {
    if (TwilioConfig.isConfigured) {
      _twilioFlutter = TwilioFlutter(
        accountSid: TwilioConfig.accountSid,
        authToken: TwilioConfig.authToken,
        twilioNumber: TwilioConfig.twilioNumber,
      );
    }
  }

  /// Send OTP to the given phone number
  /// Returns true if SMS was sent successfully, false otherwise
  static Future<bool> sendOtp({
    required String phoneNumber,
    required String otp,
    String countryCode = '+91',
  }) async {
    try {
      // Format phone with country code if not already present
      final formattedPhone = phoneNumber.startsWith('+')
          ? phoneNumber
          : '$countryCode$phoneNumber';

      // Check if Twilio is configured
      if (_twilioFlutter == null || !TwilioConfig.isConfigured) {
        // Development fallback: log OTP to console
        print('DEV MODE - OTP for $formattedPhone: $otp');
        return true;
      }

      // Send SMS via Twilio
      await _twilioFlutter!.sendSMS(
        toNumber: formattedPhone,
        messageBody:
            'Your TBS School verification code is: $otp. Valid for 10 minutes. Do not share this code with anyone.',
      );

      return true;
    } catch (e) {
      print('SMS Error: $e');
      // In development, still return true so the flow continues
      if (!TwilioConfig.isConfigured) {
        return true;
      }
      return false;
    }
  }
}

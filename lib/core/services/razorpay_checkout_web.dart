import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';

@JS('Razorpay')
extension type _Razorpay._(JSObject _) implements JSObject {
  external factory _Razorpay(JSObject options);
  external void open();
}

/// Opens Razorpay checkout using the JavaScript SDK (for web platform).
/// Requires <script src="https://checkout.razorpay.com/v1/checkout.js"> in index.html.
void openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required void Function(String paymentId) onSuccess,
  required void Function(int code, String description) onError,
}) {
  try {
    final fullOptions = Map<String, dynamic>.from(options);

    // Add success handler.
    fullOptions['handler'] = ((JSObject response) {
      String paymentId = '';
      try {
        final id = response.getProperty<JSAny?>('razorpay_payment_id'.toJS);
        paymentId = id.isA<JSString>() ? (id as JSString).toDart : '';
        debugPrint('Razorpay Web: paymentId=$paymentId');
      } catch (e) {
        debugPrint('Razorpay Web: Error reading razorpay_payment_id: $e');
      }
      debugPrint('Razorpay Web Success: paymentId=$paymentId');
      onSuccess(paymentId);
    }).toJS;

    // Add modal dismiss handler.
    fullOptions['modal'] = {
      'ondismiss': ((JSAny? reason) {
        debugPrint(
            'Razorpay Web: Checkout dismissed by user (reason: $reason)');
        onError(2, 'Payment cancelled by user');
      }).toJS,
    };

    // Convert options map to a JS object and open checkout.
    final jsOptions = fullOptions.jsify() as JSObject;
    final rzp = _Razorpay(jsOptions);
    rzp.open();

    debugPrint('Razorpay Web: Checkout opened successfully');
  } catch (e) {
    debugPrint('Razorpay Web Error: $e');
    onError(0, 'Failed to open Razorpay checkout: $e');
  }
}

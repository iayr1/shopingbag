import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': (amount * 100).toInt(),  // Amount in the smallest currency unit
      'name': 'E-commerce App',
      'description': 'Payment for your order',
      'prefill': {
        'contact': '9999999999',
        'email': 'example@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment successful: ${response.paymentId}');
    // Handle successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code} - ${response.message}');
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
    // Handle external wallet selection
  }

  void dispose() {
    _razorpay.clear();
  }
}

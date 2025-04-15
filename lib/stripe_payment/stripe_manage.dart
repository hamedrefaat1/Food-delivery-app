import 'package:dio/dio.dart';
import 'package:ecomarce/stripe_payment/stripe_keys.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String client_secret =
          await getClientSecret((amount * 100).toInt().toString(), currency);
      await initializePaymentSheet(client_secret);
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    var response = await dio.post('https://api.stripe.com/v1/payment_intents',
        options: Options(headers: {
          "Authorization": "Bearer ${ApiKeys.secretKey}",
          "content-Type": "application/x-www-form-urlencoded",
        }),
        data: {
          "amount": amount,
          "currency": currency,
        });
    return response.data["client_secret"];
  }

  static Future<void> initializePaymentSheet(String client_secret) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: client_secret,
            merchantDisplayName: "Food_Dlivey"));
  }
}

import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class StripeService {
  static const String _secretKey = "sk_test_51QWchmBh2HqsQbF7Gkd41qebqolEJQL9vKuHKZaYZczbYwSQaowbgMRDUroOnZe486eVBUAv1fFPDjd2KzKOk3pq00M2rFrP9i";
  static const String _apiUrl = "https://api.stripe.com/v1/payment_intents";

  static Future<bool> makePayment({required double amount}) async {
    try {
      final int amountInCents = (amount * 100).toInt();

      // Step 1: Create a Payment Intent
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer $_secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "amount": amountInCents.toString(),
          "currency": "usd",
          "payment_method_types[]": "card",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create Payment Intent");
      }

      final paymentIntent = jsonDecode(response.body);

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent["client_secret"],
          merchantDisplayName: "E-Commerce App",
        ),
      );

      // Step 3: Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      debugPrint("Payment error: $e");
      return false;
    }
  }

}

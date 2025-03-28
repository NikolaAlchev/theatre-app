import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:theatre_app/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(String playTitle) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(1, "usd");

      if (paymentIntentClientSecret == null) {
        return null;
      }

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentClientSecret,
              merchantDisplayName: "Nikola Alchev"));

      await _processPayment(playTitle);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment(String playTitle) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await _addPlayToBoughtList(playTitle);
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }

  Future<void> _addPlayToBoughtList(String playTitle) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      DocumentSnapshot userDoc = await userRef.get();

      List<String> boughtPlays = [];

      // Check if 'boughtPlays' field exists
      if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('boughtPlays')) {
          boughtPlays = List<String>.from(data['boughtPlays']);
        }
      }

      if (!boughtPlays.contains(playTitle)) {
        boughtPlays.add(playTitle);
      }

      // Update or create the 'favorites' field
      await userRef.set({'boughtPlays': boughtPlays}, SetOptions(merge: true));
    } catch (e) {
      print("Error adding to bought list: $e");
    }
  }
}

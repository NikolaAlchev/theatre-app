import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:theatre_app/consts.dart';
import 'package:theatre_app/plays_data.dart';
import 'package:theatre_app/screens/register_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PlayRepository().loadPlays();

  Stripe.publishableKey = stripePublishableKey;

  runApp(const TheatreApp());
}

class TheatreApp extends StatelessWidget {
  const TheatreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theatre App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const RegisterScreen(),
    );
  }
}

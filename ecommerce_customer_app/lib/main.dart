import 'dart:io';

import 'package:ecommerce_customer_app/auth/customer_signin.dart';
import 'package:ecommerce_customer_app/auth/customer_signup.dart';
import 'package:ecommerce_customer_app/main_screens/customer_home.dart';
import 'package:ecommerce_customer_app/main_screens/onboarding_screen.dart';
import 'package:ecommerce_customer_app/providers/cart_provider.dart';
import 'package:ecommerce_customer_app/providers/id_provider.dart';
import 'package:ecommerce_customer_app/providers/stripe_id.dart';
import 'package:ecommerce_customer_app/providers/wish_provider.dart';
import 'package:ecommerce_customer_app/services/notifications_services.dart';
import 'package:ecommerce_customer_app/shared/constanst.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Customer App ===> Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print(
      "Customer App ===> Handling a background message: ${message.data['key1']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationsServices.createNotificationChanelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: Constants.apiKey,
              appId: Constants.appId,
              messagingSenderId: Constants.messagingSenderId,
              projectId: Constants.projectId,
              storageBucket: Constants.storageBucket,
            )
          : null);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
    ChangeNotifierProvider(create: (_) => IdProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const Onboardingscreen(),
        '/customer_screen': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_signin': (context) => const CustomerSignin(),
      },
    );
  }
}

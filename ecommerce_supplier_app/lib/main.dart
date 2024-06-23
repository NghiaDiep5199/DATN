import 'dart:io';

import 'package:ecommerce_supplier_app/auth/supplier_signin.dart';
import 'package:ecommerce_supplier_app/auth/supplier_signup.dart';
import 'package:ecommerce_supplier_app/main_screens/onboarding_screen.dart';
import 'package:ecommerce_supplier_app/main_screens/supplier_home.dart';
import 'package:ecommerce_supplier_app/services/notifications_services.dart';
import 'package:ecommerce_supplier_app/shared/constanst.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Handling a background message: ${message.data['key1']}");
}

void main() async {
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
  NotificationsServices.createNotificationChanelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/supplier_signin',
      routes: {
        '/onboarding_screen': (context) => const Onboardingscreen(),
        '/supplier_screen': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierResgister(),
        '/supplier_signin': (context) => const SupplierSignin(),
      },
    );
  }
}

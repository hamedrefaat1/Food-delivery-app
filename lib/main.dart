import 'package:ecomarce/admin/add_food_item.dart';
import 'package:ecomarce/admin/admin_login.dart';
import 'package:ecomarce/admin/home_admin.dart';
import 'package:ecomarce/firebase_options.dart';
import 'package:ecomarce/pages/bottomNav.dart';
import 'package:ecomarce/pages/home.dart';
import 'package:ecomarce/pages/login.dart';
import 'package:ecomarce/pages/onboard.dart';
import 'package:ecomarce/pages/signup.dart';
import 'package:ecomarce/stripe_payment/stripe_keys.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  Stripe.publishableKey= ApiKeys.publishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Bottomnav());
  }
}

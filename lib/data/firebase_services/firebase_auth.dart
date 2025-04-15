// ignore_for_file: use_build_context_synchronously

import 'package:ecomarce/data/firebase_services/firebase_store.dart';
import 'package:ecomarce/data/shared_pref/shared_pref.dart';
import 'package:ecomarce/pages/bottomNav.dart';
import 'package:ecomarce/util/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthMetods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
             String userId = _auth.currentUser!.uid;

      // إنشاء المستخدم في Firestore
      await FirebaseStoreMethods().addUserInfo(
        userId: userId,
        name: name,
        email: email,
      );

      // حفظ بيانات المستخدم في SharedPreferences
      await SharedPrefServices().saveUserData(
        userId: userId,
        name: name,
        email: email,
      );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Rigestred Successfully",
              style: TextStyle(fontSize: 20),
            )));
      } else {
        throw exceptions("enter all a fileds");
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Bottomnav()));
    } on FirebaseAuthException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        throw exceptions("Please enter both email and password.");
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Bottomnav()));
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}

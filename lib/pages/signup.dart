// ignore_for_file: prefer_const_constructors

import 'package:ecomarce/data/firebase_services/firebase_auth.dart';
import 'package:ecomarce/pages/login.dart';
import 'package:ecomarce/util/dialog.dart';
import 'package:ecomarce/util/exceptions.dart';
import 'package:ecomarce/widgets/shared_widget.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color(0xFFff5c30),
                      Color(0xFFe74b1a),
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(top: 60, right: 20, left: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "images/logo.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "SignUp",
                                style: SharedWidget.headLineTextStyle(),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter a name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle:
                                        SharedWidget.semiBoldtTextStyle(),
                                    prefixIcon: Icon(Icons.person)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter a email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle:
                                        SharedWidget.semiBoldtTextStyle(),
                                    prefixIcon: Icon(Icons.email_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter a password";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle:
                                        SharedWidget.semiBoldtTextStyle(),
                                    prefixIcon: Icon(Icons.password_outlined)),
                              ),
                              SizedBox(
                                height: 80.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                   try {
                                       await FirebaseAuthMetods().signUp(
                                        name: name.text,
                                        email: email.text,
                                        password: password.text,
                                        context: context);
                                   } on exceptions catch (e) {
                                        dailogBulider(context, e.massege);
                                   }
                                  }
                                },
                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Color(0Xffff5722),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          "Signup",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontFamily: 'Poppins1',
                                              fontWeight: FontWeight.bold),
                                        )))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: SharedWidget.semiBoldtTextStyle(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

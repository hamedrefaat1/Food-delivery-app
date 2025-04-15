// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecomarce/data/firebase_services/firebase_store.dart';
import 'package:ecomarce/data/shared_pref/shared_pref.dart';
import 'package:ecomarce/stripe_payment/stripe_manage.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletBalance = 0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadedWalletBalance();
  }

  Future<void> loadedWalletBalance() async {
    double? balance = await SharedPrefServices().getUserWallet();
    setState(() {
      walletBalance = balance;
    });
  }

  Future<void> addMoney(double amount) async {
    try {
      await PaymentManager.makePayment(amount.toInt(), "EGP");

      double newBalance = walletBalance + amount;
      String? userId = await SharedPrefServices().getUserId();
      await FirebaseStoreMethods().updateWalletBalance(userId!, newBalance);
      await SharedPrefServices().setWalletBalance(newBalance);
      setState(() {
        walletBalance = newBalance;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wallet updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ًWallet",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset(
                    "images/wallet.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Wallet",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "\$${walletBalance.toString()}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Add money",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                double amount = [100,500,1000,2000][index].toDouble(); 
                return GestureDetector(
                  onTap:(){
                      addMoney(amount);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "\$${amount.toString()}",
                      style:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
            ),
             SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                double? amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  addMoney(amount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Enter a valid amount"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(vertical: 12.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

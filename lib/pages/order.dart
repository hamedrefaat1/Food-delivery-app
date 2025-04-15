import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce/data/firebase_services/firebase_store.dart';
import 'package:ecomarce/data/shared_pref/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // دالة لحذف العنصر من السلة
  Future<void> _deleteCartItem(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .doc(itemId)
          .delete();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

// to completet payment process
  Future<void> checkOut(double totalPrice) async {
    try {
      double walletBalance = await SharedPrefServices().getUserWallet();

      if (totalPrice > walletBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Insufficient wallet balance!"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      double newBalance = walletBalance - totalPrice;
      await FirebaseStoreMethods().updateWalletBalance(userId!, newBalance);
      await SharedPrefServices().setWalletBalance(newBalance);

      var cartItems = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .get();

      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Payment successful!"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        
      });
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      print("Error during checkout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Orders",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: userId == null
          ? const Center(
              child: Text(
                "Please log in first",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userId)
                  .collection("cart")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                double totalPrice = 0.0;
                for (var doc in snapshot.data!.docs) {
                  totalPrice += (doc["totalPrice"] as num).toDouble();
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var cartItem = snapshot.data!.docs[index];
                          return _buildCartItemCard(cartItem);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              checkOut(totalPrice);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Proceed to Checkout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildCartItemCard(
      QueryDocumentSnapshot<Map<String, dynamic>> cartItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cartItem["imageUrl"],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem["name"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Quantity: ${cartItem["quantity"]}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "\$${cartItem["totalPrice"].toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                _deleteCartItem(
                    cartItem.id); // حذف العنصر عند الضغط على الأيقونة
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

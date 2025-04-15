import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce/data/firebase_services/firebase_store.dart';
import 'package:ecomarce/widgets/shared_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final item;
  const DetailsScreen({this.item, super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;


  // دالة لإضافة العنصر إلى عربة التسوق
  Future<void> _addToCart() async {
    try {
      // الحصول على userId الخاص بالمستخدم الحالي
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("User not logged in");
        return;
      }

      // إنشاء Map يحتوي على بيانات العنصر
      Map<String, dynamic> itemFoodInfo = {
        "name": widget.item["name"],
        "imageUrl": widget.item["imageUrl"],
        "quantity": quantity,
        "totalPrice": widget.item["price"] * quantity,
        "addedAt": FieldValue.serverTimestamp(),
      };

      // إضافة العنصر إلى عربة التسوق
    await FirebaseStoreMethods().addItemFoodInCart(itemFoodInfo, userId);

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text("Item added to cart successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // إظهار رسالة خطأ في حالة فشل العملية
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add item to cart: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("Error adding item to cart: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // صورة المنتج كخلفية
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5, // 50% من ارتفاع الشاشة
            child: Image.network(
              widget.item["imageUrl"],
              fit: BoxFit.cover,
            ),
          ),

          // زر الرجوع للخلف
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // الجزء السفلي من الشاشة (التفاصيل)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55, // 55% من ارتفاع الشاشة
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, -3)),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    widget.item["name"],
                    style: SharedWidget.semiBoldtTextStyle().copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  // وصف المنتج
                  Text(
                    widget.item['details'],
                    style: SharedWidget.lightTextStyle().copyWith(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),

                  // تحديد الكمية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _quantityButton(Icons.remove, () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      }),
                      SizedBox(width: 20),
                      Text(
                        "$quantity",
                        style: SharedWidget.blodTextStyle().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      _quantityButton(Icons.add, () {
                        setState(() {
                          quantity++;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 30),

                  // وقت التوصيل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.alarm, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        "30 min",
                        style: SharedWidget.semiBoldtTextStyle().copyWith(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // السعر وزر الإضافة للسلة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Price",
                            style: SharedWidget.semiBoldtTextStyle().copyWith(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "\$${(widget.item["price"] * quantity).toStringAsFixed(2)}",
                            style: SharedWidget.semiBoldtTextStyle().copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _addToCart,
                        child: _addToCartButton()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(12),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _addToCartButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add to cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
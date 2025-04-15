import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo({
    required String email,
    required String name,
    required String userId,
  }) async {
    await _firestore.collection("users").doc(userId).set({
      "id": userId,
      "email": email,
      "name": name,
      "wallet": 0,
    });
  }

  Future<bool> updateWalletBalance(String userId, double amount) async {
    try {
      await _firestore.collection("users").doc(userId).update({
        "wallet": FieldValue.increment(amount),
      });
      return true;
    } catch (e) {
      print("❌ Error updating wallet balance: $e");
      return false;
    }
  }

  Future<void> addFoodItem({
    required String name,
    required double price,
    required String details,
    required String category,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection("foodItems").add({
        "name": name,
        "price": price,
        "details": details,
        "category": category,
        "imageUrl": imageUrl,
        "createdAt": FieldValue.serverTimestamp()
      });
    } catch (e) {
      print("Error adding food item $e");
    }
  }

  Future addItemFoodInCart(Map<String, dynamic> itemFoodInfo, userId )async{
    await _firestore.collection("users").doc(userId).collection("cart").add(itemFoodInfo);
  }
}

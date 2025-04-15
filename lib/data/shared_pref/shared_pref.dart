
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  Future<void> saveUserData({
    required String email,
    required String name,
    required String userId,
  })async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("name", name);
    await prefs.setString("userId", userId);
    await prefs.setDouble("wallet", 0);
  }

  Future<bool> setWalletBalance(double balance) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("wallet", balance);
    return true;
  } catch (e) {
    print("❌ Error saving wallet balance: $e");
    return false;
  }
}
  Future<String?> getUserEmail()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("email");
  }
    Future<String?> getUserName()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("name");
  }
    Future<String?> getUserId()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("userId");
  }
Future<double> getUserWallet() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getDouble("wallet") ?? prefs.getInt("wallet")?.toDouble() ?? 0.0);
}

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // يمسح جميع البيانات المخزنة
  }
}
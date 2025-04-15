import 'package:ecomarce/data/shared_pref/shared_pref.dart';
import 'package:ecomarce/pages/login.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPrefServices userInfo = SharedPrefServices();
    String? fetchedName = await userInfo.getUserName();
    String? fetchedEmail = await userInfo.getUserEmail();

    setState(() {
      name = fetchedName ?? "No Name"; // في حالة كانت القيمة `null`
      email = fetchedEmail ?? "No Email";
    });
  }

    Future<void> _logout() async {
    SharedPrefServices userInfo = SharedPrefServices();
    await userInfo.clearUserData(); // حذف بيانات المستخدم

    // إعادة التوجيه إلى شاشة تسجيل الدخول
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.0),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/person.png"),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              name, // استبدله باسم المستخدم الفعلي
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              email, // استبدله بالإيميل الفعلي
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // أضف هنا منطق تسجيل الخروج
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: GestureDetector(
                  onTap:_logout,
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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

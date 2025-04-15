import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce/data/shared_pref/shared_pref.dart';
import 'package:ecomarce/pages/details.dart';
import 'package:ecomarce/widgets/shared_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> imagesPath = [
    "images/ice-cream.png",
    "images/burger.png",
    "images/pizza.png",
    "images/salad.png",
  ];
  int selectIndex = -1;

  String selectedCategory = "";
  List<Map<String, dynamic>> foodItems = [];

  String getCategoryName(int index) {
    List<String> categories = ['Ice-cream', 'Burger', 'Pizza', 'Salad'];
    return categories[index];
  }

  // دالة لجلب الأطعمة مع أو بدون تحديد الفئة
  void fetchFoodItems({String? category}) async {
    QuerySnapshot querySnapshot;
    if (category == null || category.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection("foodItems")
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection("foodItems")
          .where("category", isEqualTo: category)
          .get();
    }

    setState(() {
      foodItems = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  String? name = "";

  @override
  void initState() {
    super.initState();
    loadedName();
    fetchFoodItems(); // جلب جميع الأطعمة عند فتح التطبيق لأول مرة
  }

  loadedName() async {
    SharedPrefServices userData = SharedPrefServices();
    name = await userData.getUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello $name", style: SharedWidget.blodTextStyle()),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delicious food",
                      style: SharedWidget.headLineTextStyle()),
                  Text("Discover and Get Great Food",
                      style: SharedWidget.lightTextStyle()),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(imagesPath.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = getCategoryName(index);
                            fetchFoodItems(category: selectedCategory);
                            selectIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectIndex == index
                                ? Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            imagesPath[index],
                            height: 40,
                            width: 40,
                            color: selectIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  // زر "All" لعرض جميع الأطعمة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = "";
                            fetchFoodItems();
                            selectIndex = -1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: selectedCategory.isEmpty
                                ? Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            "All",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedCategory.isEmpty
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Food Items List (Scrollable)
            Expanded(
              child: foodItems.isEmpty
                  ? Center(
                      child: Text(
                        "No items available",
                        style: SharedWidget.lightTextStyle(),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        var item = foodItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(item: item),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: item['imageUrl'] ?? '',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'images/loading.gif', // صورة مؤقتة أثناء التحميل
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'images/burger.png', // صورة بديلة في حالة الخطأ
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? '',
                                          style:
                                              SharedWidget.semiBoldtTextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          item['details'] ?? '',
                                          style: SharedWidget.lightTextStyle(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "\$${item['price'].toString()}",
                                          style:
                                              SharedWidget.semiBoldtTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
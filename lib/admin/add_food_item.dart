import 'dart:io';
import 'package:ecomarce/data/firebase_services/firebase_store.dart';
import 'package:ecomarce/data/firebase_services/storage.dart';
import 'package:ecomarce/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:ecomarce/widgets/shared_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodItem extends StatefulWidget {
  const AddFoodItem({super.key});

  @override
  State<AddFoodItem> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final List<String> fooditems = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController detailcontroller = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectImage;

  bool isLoading = false;

  @override
  void dispose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    detailcontroller.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // تجنب الأخطاء عند إلغاء الاختيار
    setState(() {
      selectImage = File(image.path);
    });
  }

  Future<void> addFoodItem() async {
    if (selectImage == null ||
        namecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty ||
        detailcontroller.text.isEmpty ||
        value == null) {
      dailogBulider(context, "⚠️ تأكد من ملء جميع الحقول");
      return;
    }

    setState(() {
      isLoading = true; // بدء التحميل
    });

    try {
      String imageUrl =
          await FirebaseStorageMethods().uploadImageItem(selectImage!);

      await FirebaseStoreMethods().addFoodItem(
        name: namecontroller.text,
        price: double.tryParse(pricecontroller.text) ?? 0.0,
        details: detailcontroller.text,
        category: value!,
        imageUrl: imageUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("✅ Item added successfully!"),
        backgroundColor: Colors.green,
      ));

      setState(() {
        selectImage = null;
        namecontroller.clear();
        pricecontroller.clear();
        detailcontroller.clear();
        value = null;
      });
    } catch (e) {
      dailogBulider(context, "❌ حدث خطأ أثناء إضافة المنتج: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false; // إيقاف التحميل بعد الانتهاء
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("Add Item", style: SharedWidget.headLineTextStyle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload the Item Picture",
                style: SharedWidget.semiBoldtTextStyle()),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: getImage,
              child: Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: selectImage == null
                        ? const Icon(Icons.camera_alt_outlined,
                            color: Colors.black)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(selectImage!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            _buildTextField("Item Name", "Enter Item Name", namecontroller),
            const SizedBox(height: 30.0),
            _buildTextField("Item Price", "Enter Item Price", pricecontroller,
                isNumeric: true),
            const SizedBox(height: 30.0),
            _buildTextField(
                "Item Detail", "Enter Item Detail", detailcontroller,
                maxLines: 6),
            const SizedBox(height: 20.0),
            Text("Select Category", style: SharedWidget.semiBoldtTextStyle()),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: fooditems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black)),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => this.value = value),
                  dropdownColor: Colors.white,
                  hint: const Text("Select Category"),
                  iconSize: 36,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50.0),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed:
                    isLoading ? null : addFoodItem, // تعطيل الزر أثناء التحميل
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add",
                        style: TextStyle(fontSize: 22.0, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {int maxLines = 1, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SharedWidget.semiBoldtTextStyle()),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: SharedWidget.lightTextStyle(),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageMethods{
    final FirebaseStorage _storage = FirebaseStorage.instance;
    var uid = Uuid().v4();

    Future<String>uploadImageItem(File file)async{
        Reference ref =_storage.ref().child("foodItems").child(uid);
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downLoadUrl =await snapshot.ref.getDownloadURL();
        return downLoadUrl;
    }
}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageHelper {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadProfileFile(File file, String path) async {
      var uid = Uuid().v4();
      TaskSnapshot snapshot = await _firebaseStorage
        .ref()
        .child(path)
        .child(uid)
        .putFile(file);
      if (snapshot.state == TaskState.success) {
        return await snapshot.ref.getDownloadURL();
      } else {
        print('Error from image repo ${snapshot.state.toString()}');
      }
    return "";
  }

  static Future<String> uploadGalleryFile(File file, String userUid) async {
    var uid = Uuid().v4();
    TaskSnapshot snapshot = await _firebaseStorage
      .ref()
      .child("gallery/")
      .child(userUid)
      .child(uid)
      .putFile(file);
    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    } else {
      print('Error from image repo ${snapshot.state.toString()}');
    }
    return "";
  }
  
}
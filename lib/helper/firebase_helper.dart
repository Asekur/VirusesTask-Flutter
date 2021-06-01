// ignore: import_of_legacy_library_into_null_safe
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/virus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class DatabaseHelper {
  static final _firebaseDatabase = FirebaseDatabase.instance.reference();

  static Future<Virus?> getVirus(String fullName) async {
    List<Virus> viruses = await fetchViruses();
    return viruses.firstWhereOrNull((virus) => virus.fullName == fullName);
  }

  // галерея для определенного пользователя
  static Future<List<String>> fetchGallery(String uid) async {
    List<String> urls = [];
    
    
    try {
      await _firebaseDatabase
          .reference()
          .child("gallery/")
          .child(uid)
          .once().then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        for (var key in keys) {
          urls.add(data[key]);
        }
      });
    } catch (ex) {
        Fluttertoast.showToast(
          msg: "No items",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          fontSize: 16
        );
    }
    return urls;
  }

  static Future<void> saveGalleryPhoto(String virusUid, String photoUrl) async {
    var randUid = Uuid().v4();
    _firebaseDatabase
        .reference()
        .child("gallery/")
        .child(virusUid)
        .update({
      randUid: photoUrl
    });
  }

  static Future<List<Virus>> fetchViruses() async {
    List<Virus> viruses = [];
    await _firebaseDatabase
      .reference()
      .child("Viruses/")
      .once().then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        for(var key in keys) {
          try {
            viruses.add(new Virus(
              data[key]["uid"],
              data[key]["fullName"],
              data[key]["country"],
              data[key]["continent"],
              data[key]["domain"],
              data[key]["mortality"],
              data[key]["password"],
              data[key]["year"],
              data[key]["photo_link"],
              data[key]["video_link"])
            );
          } catch (e) {
        }
      }
    });
    return viruses;
  }
}
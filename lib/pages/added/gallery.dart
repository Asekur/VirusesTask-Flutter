// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/firebase_helper.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/helper/upload_storage.dart';
import 'package:image_picker/image_picker.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<String> images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _imgFromGallery() async {
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      var url = await StorageHelper.uploadGalleryFile(File(pickedFile.path), "gallery/");
      DatabaseHelper.saveGalleryPhoto(Session.shared.detailVirus.uid, url).then((value) {
        fetchImages();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void fetchImages() {
    DatabaseHelper.fetchGallery(Session.shared.detailVirus.uid).then((value) {
      setState(() {
        images = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo_outlined),
            tooltip: "Add photo",
            color: Colors.white,
            iconSize: 30,
            onPressed: () async {
              if (Session.shared.detailVirus.uid == Session.shared.virus.uid) {
                  _imgFromGallery();
                }
            }
          ),
        ]
      ),
      body: Container(
        color: Colors.white30,
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(1.0),
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: List.generate(images.length, (index) {
            return Card(
              child: Card(
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    images.elementAt(index).isNotEmpty ? 
                      images.elementAt(index) : null                    
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
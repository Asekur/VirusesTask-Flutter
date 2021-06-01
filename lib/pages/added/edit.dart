// @dart=2.9
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/firebase_helper.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/helper/upload_storage.dart';
import 'package:flutter_viruses/helper/virus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  PickedFile _image;
  bool pickedImage = false;
  final ImagePicker _picker = ImagePicker();
  static final _firebaseDatabase = FirebaseDatabase.instance.reference();

  TextEditingController _fullnameEditController;
  TextEditingController _countryEditController;
  TextEditingController _continentEditController;
  TextEditingController _domainEditController;
  TextEditingController _yearEditController;
  TextEditingController _mortalityEditController;
  TextEditingController _videolinkEditController;
  TextEditingController _passwordEditController;
  final _formEditKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fullnameEditController = TextEditingController(text: Session.shared.virus.fullName);
    _countryEditController = TextEditingController(text: Session.shared.virus.country);
    _continentEditController = TextEditingController(text: Session.shared.virus.continent);
    _domainEditController = TextEditingController(text: Session.shared.virus.domain);
    _yearEditController = TextEditingController(text: Session.shared.virus.year);
    _mortalityEditController = TextEditingController(text: Session.shared.virus.mortality);
    _videolinkEditController = TextEditingController(text: Session.shared.virus.videoLink);
    _passwordEditController = TextEditingController(text: Session.shared.virus.password);
    super.initState();
  }

  @override
  void dispose() {
    _fullnameEditController.dispose();
    _countryEditController.dispose();
    _continentEditController.dispose();
    _domainEditController.dispose();
    _yearEditController.dispose();
    _mortalityEditController.dispose();
    _videolinkEditController.dispose();
    _passwordEditController.dispose();
    super.dispose();
  }

    _imgFromGallery() async {
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      setState(() {
        _image = pickedFile;
        pickedImage = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void saveChange() async {
    var exist = await DatabaseHelper.getVirus(_fullnameEditController.text);
    if (exist != null && exist.fullName != Session.shared.virus.fullName) {
      Fluttertoast.showToast(
        msg: "User is already exists!",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        fontSize: 16
      );
    } else {
      var country = StringUtils.isNullOrEmpty(_countryEditController.text) ? "Country" : _countryEditController.text;
      var continent = StringUtils.isNullOrEmpty(_continentEditController.text) ? "Continent" : _continentEditController.text;
      var domain = StringUtils.isNullOrEmpty(_domainEditController.text) ? "Domain" : _domainEditController.text;
      var year = StringUtils.isNullOrEmpty(_yearEditController.text) ? "Year" : _yearEditController.text;
      var mortality = StringUtils.isNullOrEmpty(_mortalityEditController.text) ? "Mortality" : _mortalityEditController.text;
      var videoLink = StringUtils.isNullOrEmpty(_videolinkEditController.text) ? "https://archive.org/download/ElephantsDream/ed_1024.mp4" : _videolinkEditController.text;

      var virus = Virus(
        Session.shared.virus.uid,
        _fullnameEditController.text,
        country,
        continent,
        domain,
        mortality,
        _passwordEditController.text,
        year,
        Session.shared.virus.photoLink,
        videoLink
      );
    
      if (pickedImage == true && _image != null) {
        var url = await StorageHelper.uploadProfileFile(File(_image.path), "Viruses");
        virus.photoLink = url;
      }

      _firebaseDatabase.reference()
        .child("Viruses")
        .child(virus.uid)
        .set({
          "uid": virus.uid,
          "fullName": virus.fullName,
          "country": virus.country,
          "continent": virus.continent,
          "domain": virus.domain,
          "mortality": virus.mortality,
          "password": virus.password,
          "year": virus.year,
          "photo_link": virus.photoLink,
          "video_link": virus.videoLink,
        });
        
      Session.shared.virus = virus;  
      Fluttertoast.showToast(
        msg: "Success!",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        fontSize: 16
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formEditKey,
              child: Column(
                children: [
                Container(
                  width: 165,
                  height: 165, 
                  child: GestureDetector(
                    onTap: () {
                        _imgFromGallery();
                    },
                    child: 
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: _image != null ? 
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.file(
                                    File(_image.path),
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                        : 
                        Container(
                          decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover, 
                            image: NetworkImage(Session.shared.virus.photoLink)
                          ),
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(80)),
                          width: 160,
                          height: 160,
                        ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _fullnameEditController,
                  validator: (value) => value.isNotEmpty ? null : "Enter name!",
                  decoration: InputDecoration(
                    hintText: "editFullname".tr(),
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _countryEditController,
                  decoration: InputDecoration(
                    hintText: "editCountry".tr(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _continentEditController,
                  decoration: InputDecoration(
                    hintText: "editContinent".tr(),
                    prefixIcon: Icon(Icons.public_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _domainEditController,
                  decoration: InputDecoration(
                    hintText: "editDomain".tr(),
                    prefixIcon: Icon(Icons.group_work_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _yearEditController,
                  decoration: InputDecoration(
                    hintText: "editYear".tr(),
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _mortalityEditController,
                  decoration: InputDecoration(
                    hintText: "editMortality".tr(),
                    prefixIcon: Icon(Icons.warning_amber_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _videolinkEditController,
                  decoration: InputDecoration(
                    hintText: "editVideolik".tr(),
                    prefixIcon: Icon(Icons.videocam_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordEditController,
                  validator: (value) => value.isNotEmpty ? null : "Enter password!",
                  decoration: InputDecoration(
                    hintText: "editPassword".tr(),
                    prefixIcon: Icon(
                      Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [ 
                  IconButton(
                    onPressed: () {
                      if (_formEditKey.currentState.validate()) {
                        print("Fullname: ${_fullnameEditController.text}");
                        print("Password: ${_passwordEditController.text}");
                        saveChange();
                      }
                    }, 
                    color: Colors.lightGreen,
                    iconSize: 40,
                    icon: Icon(Icons.save_alt_outlined)
                  ),
                  ],
                ),
              ]),
            )
          ),
        ),
      )
    );
  }
}
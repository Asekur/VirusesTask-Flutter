// @dart=2.9
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/firebase_helper.dart';
import 'package:flutter_viruses/helper/upload_storage.dart';
import 'package:flutter_viruses/helper/virus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';

const video_link = "https://archive.org/download/ElephantsDream/ed_1024.mp4";
const photo_link = "https://firebasestorage.googleapis.com/v0/b/viruses-5d58d.appspot.com/o/7.png?alt=media&token=9d65b7d3-ea83-4e43-94b5-5cc75becf5bd";

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  PickedFile _image;
  bool pickedImage = false;
  static final _firebaseDatabase = FirebaseDatabase.instance.reference();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _fullnameController;
  TextEditingController _countryController;
  TextEditingController _continentController;
  TextEditingController _domainController;
  TextEditingController _yearController;
  TextEditingController _mortalityController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fullnameController = TextEditingController();
    _countryController = TextEditingController();
    _continentController = TextEditingController();
    _domainController = TextEditingController();
    _yearController = TextEditingController();
    _mortalityController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _countryController.dispose();
    _continentController.dispose();
    _domainController.dispose();
    _yearController.dispose();
    _mortalityController.dispose();
    _passwordController.dispose();
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

  void register() async {
    var exist = await DatabaseHelper.getVirus(_fullnameController.text);
    if (exist == null) {
      var country = StringUtils.isNullOrEmpty(_countryController.text) ? "Country" : _countryController.text;
      var continent = StringUtils.isNullOrEmpty(_continentController.text) ? "Continent" : _continentController.text;
      var domain = StringUtils.isNullOrEmpty(_domainController.text) ? "Domain" : _domainController.text;
      var year = StringUtils.isNullOrEmpty(_yearController.text) ? "Year" : _yearController.text;
      var mortality = StringUtils.isNullOrEmpty(_mortalityController.text) ? "Mortality" : _mortalityController.text;

      var virus = Virus(
        Uuid().v4(),
        _fullnameController.text,
        country,
        continent,
        domain,
        mortality,
        _passwordController.text,
        year,
        photo_link,
        video_link
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
        
      Fluttertoast.showToast(
        msg: "Created!",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        fontSize: 16
      );
    } else {
      Fluttertoast.showToast(
        msg: "User is already exists!",
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                Container(
                  width: 165,
                  height: 165, 
                  child: GestureDetector(
                    onTap: () {
                        _imgFromGallery();
                    },
                    child: CircleAvatar(
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
                          color: Theme.of(context).hintColor,
                          borderRadius: BorderRadius.circular(80)),
                          width: 160,
                          height: 160,
                        ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _fullnameController,
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
                  controller: _countryController,
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
                  controller: _continentController,
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
                  controller: _domainController,
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
                  controller: _yearController,
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
                  controller: _mortalityController,
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
                  controller: _passwordController,
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
                SizedBox(height: 40),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print("Fullname: ${_fullnameController.text}");
                      print("Password: ${_passwordController.text}");
                      register();
                    }
                  },
                  height: 55,
                  minWidth: double.infinity,
                  color: Color(0xFF34972E),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(),
                  ),
                  child: Text(
                    "regRegister".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),  
                ),
              ]),
            )
          ),
        ),
      )
    );
  }
}

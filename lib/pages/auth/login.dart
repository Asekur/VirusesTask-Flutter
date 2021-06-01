// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/firebase_helper.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/pages/auth/register.dart';
import 'package:flutter_viruses/pages/home/tabbed.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _fullnameController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fullnameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> login() async {
    var exist = await DatabaseHelper.getVirus(_fullnameController.text);
    if (exist != null) {
      //проверка пароля
      if (exist.password == _passwordController.text) {
        Session.shared.virus = exist;
        Session.shared.viruses = await DatabaseHelper.fetchViruses();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Incorrect password!",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[900],
          textColor: Colors.white,
          fontSize: 16
        );
        return false;
      }
    } else {
      Fluttertoast.showToast(
        msg: "User doesn't exist!",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[900],
        textColor: Colors.white,
        fontSize: 16
      );
      return false;
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
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                    "assets/virus.png",
                    height: 190,
                  ),
                  ],
                ),
                SizedBox(height: 50),
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
                  controller: _passwordController,
                  validator: (value) => value.isNotEmpty ? null : "Enter password!",
                  decoration: InputDecoration(
                    hintText: "editPassword".tr(),
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                SizedBox(height: 60),
                MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print("Fullname: ${_fullnameController.text}");
                      print("Password: ${_passwordController.text}");
                      if (await login()) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Tabbed();
                            }
                          )
                        );
                      }
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
                    "authAuthorize".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),  
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Register();
                            }
                          )
                        );
                      }, 
                      child: Text(
                        "authTextReg".tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                        )
                    )
                  ]
                )
              ]),
            )
          ),
        ),
      )
    );
  }
}

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _modeValue = 0;
  double _fontValue = 0;

  @override
  void initState() {
    if (AdaptiveTheme.of(context).isDefault) {
      setState(() {
        _modeValue = 0;
      });
    } else {
        setState(() {
        _modeValue = 1;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child:
                        TextFormField(
                          style: TextStyle(
                            fontSize: 15 + _fontValue,
                            color: Theme.of(context).focusColor
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                          hintText: "settingsLight".tr(),       
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),         
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: new BorderSide(color: Theme.of(context).hintColor)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: new BorderSide(color: Theme.of(context).hintColor),
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child:
                        Slider(
                          value: _modeValue,
                          min: 0,
                          max: 1,
                          divisions: 1,
                          onChanged: (double value) {
                            setState(() {
                              _modeValue = value;
                               //                           AdaptiveTheme.of(context).toggleThemeMode();
                              (value.toInt() == 0) ? AdaptiveTheme.of(context).setLight() : AdaptiveTheme.of(context).setDark();
                            });
                        },)
                    )
                  ]
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child:
                        TextFormField(
                          style: TextStyle(fontSize: 15 + _fontValue),
                          readOnly: true,
                          decoration: InputDecoration(
                          hintText: "settingsFont".tr(),                
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: new BorderSide(color: Colors.grey),
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child:
                        Slider(
                          value: _fontValue,
                          min: 0,
                          max: 3,
                          divisions: 3,
                          onChanged: (double value) {
                            setState(() {
                              _fontValue = value;
                            });
                        },)
                    )
                  ]
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  MaterialButton(
                    onPressed: () { 
                       EasyLocalization.of(context)?.setLocale(Locale('en'));
                    },
                    height: 55,
                    minWidth: 150,
                    color: Color(0xFF34972E),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "settingsEng".tr(),
                      style: TextStyle(
                        fontSize: 18 + _fontValue,
                        fontWeight: FontWeight.w300,
                      ),
                    ),  
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () { 
                       EasyLocalization.of(context)?.setLocale(Locale('ru'));
                    },
                    height: 55,
                    minWidth: 150,
                    color: Color(0xFF34972E),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "settingsRus".tr(),
                      style: TextStyle(
                        fontSize: 18 + _fontValue,
                        fontWeight: FontWeight.w300,
                      ),
                    ),  
                  ),
                ],),
                SizedBox(height: 50),
                MaterialButton(
                  onPressed: () { 
                    Navigator.pop(context);
                  },
                  height: 55,
                  minWidth: double.infinity,
                  color: Color(0xFF34972E),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(),
                  ),
                  child: Text(
                    "settingsLogout".tr(),
                    style: TextStyle(
                      fontSize: 18 + _fontValue,
                      fontWeight: FontWeight.w300,
                    ),
                  ),  
                ),
              ]),
            )
          ),
        ),
      ),
    );
  }
}
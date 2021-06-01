import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_viruses/helper/firebase_helper.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/helper/virus.dart';
import 'package:flutter_viruses/pages/added/detail.dart';
import 'package:flutter_viruses/pages/added/filter_items.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<Virus> _filter = [];
  double _filterYear = 0;
  double _filterMortality = 0;
  double _filterDomain = 1;
  String _domain = "filterVirus".tr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                SizedBox(height: 50),
                SizedBox(
                  width: 230,
                  child: TextFormField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "filterYear".tr(),  
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),              
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(color: Theme.of(context).hintColor),
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
                  width: double.infinity,
                  child:
                    Slider(
                      value: _filterYear,
                      min: 0,
                      max: 100,
                      onChanged: (double value) {
                        setState(() {
                          _filterYear = value;
                        });
                    },)
                ),
                Text(
                  (_filterYear.toInt() * 2 + 1800).toString(),
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 16 
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 230,
                  child: TextFormField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "filterMortality".tr(),               
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),              
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(color: Theme.of(context).hintColor),
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
                  width: double.infinity,
                  child:
                    Slider(
                      value: _filterMortality,
                      min: 0,
                      max: 100,
                      onChanged: (double value) {
                        setState(() {
                          _filterMortality = value;
                        });
                    },)
                ),
                Text(
                  _filterMortality.toInt().toString() + "%",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 16 
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 230,
                  child: TextFormField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "editDomain".tr(),                   
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),              
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(color: Theme.of(context).hintColor),
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
                  width: double.infinity,
                  child:
                    Slider(
                      value: _filterDomain,
                      min: 0,
                      max: 1,
                      divisions: 1,
                      onChanged: (double value) {
                        setState(() {
                          _filterDomain = value;
                          (_filterDomain == 1) ? _domain = "filterVirus".tr() : _domain = "filterBacteria".tr();
                        });
                    },)
                ),
                Text(
                  _domain,
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 16 
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 50),
                MaterialButton(
                  onPressed: () async {
                    _filter = await DatabaseHelper.fetchViruses();
                    
                    Session.shared.resultViruses = _filter.where(
                      (virus) => ((virus.domain == _domain) &&
                                  (int.parse(virus.year) > _filterYear.toInt() * 2 + 1800) &&
                                  (int.parse(virus.mortality.replaceAll("%", "")) > _filterMortality.toInt()))
                    ).toList();

                    if (Session.shared.resultViruses.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "No items",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[900],
                        textColor: Colors.white,
                        fontSize: 16
                      );
                    } else {
                      if (Session.shared.resultViruses.length == 1) {
                        Session.shared.detailVirus = Session.shared.resultViruses[0];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FilterItems()));
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
                    "filterUse".tr(),
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
      ),
    );
  }
}
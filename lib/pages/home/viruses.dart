// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/pages/added/detail.dart';
import 'package:flutter_viruses/pages/added/edit.dart';
import 'package:flutter_viruses/pages/added/filter.dart';

class Viruses extends StatefulWidget {
  @override
  _VirusesState createState() => _VirusesState();
}

class _VirusesState extends State<Viruses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit_outlined),
            tooltip: "Edit profile",
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) {
                    return Edit();
                  }
                )
              ); 
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            tooltip: "Filter",
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) {
                    return Filter();
                  }
                )
              ); 
            },
          ),
        ]
      ),
      body: Container(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            padding: const EdgeInsets.all(4.0),
            children: List.generate(Session.shared.viruses.length, (index) {
              return InkWell(
                onTap: () {
                  Session.shared.detailVirus = Session.shared.viruses.elementAt(index);
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Detail()));
                },
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Colors.transparent,
                  borderOnForeground: false,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: new BoxDecoration (
                          image: new DecorationImage(
                            image: new NetworkImage(
                              Session.shared.viruses.elementAt(index).photoLink,
                            ),
                            fit: BoxFit.cover
                          ),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(40)
                          ),
                          border: new Border.all(
                            color: Theme.of(context).hintColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: 
                        Container(
                          width: 110,
                          height: 35,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(25),
                            border: Border.all(color: Theme.of(context).hintColor)
                          ),
                          child: Text( 
                            Session.shared.viruses.elementAt(index).fullName,
                          ),
                        )
                      )],
                  ),
                ),
              );
            }),
          ),
        ),
     
    );
  }
}
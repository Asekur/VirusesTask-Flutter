// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_viruses/pages/home/maps.dart';
import 'package:flutter_viruses/pages/home/settings.dart';
import 'package:flutter_viruses/pages/home/viruses.dart';

class Tabbed extends StatefulWidget {
  @override
  _TabbedState createState() => _TabbedState();
}

class _TabbedState extends State<Tabbed> {
  int _currentIndex = 0;

  final screens = [
    Viruses(),
    Maps(),
    Settings()
  ];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
        return screens[_currentIndex];
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Viruses"),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings")
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
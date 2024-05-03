// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 100, 171),
        title: const Center(
            child: Text(
          "SETTING PAGE",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'IndieFlower',
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        )),
      ),
      body: Center(
          child: Text("setting",
              style: TextStyle(
                color: Color.fromARGB(255, 11, 8, 8),
                fontFamily: 'IndieFlower',
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ))),
      backgroundColor: Color.fromARGB(255, 248, 25, 177),
    );
  }
}

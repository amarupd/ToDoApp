// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 100, 171),
        title: const Center(
            child: Text(
          "PROFILE PAGE",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'IndieFlower',
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        )),
      ),
      body: Center(
          child: Text("profile",
              style: TextStyle(
                color: Color.fromARGB(255, 11, 8, 8),
                fontFamily: 'IndieFlower',
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ))),
      backgroundColor: Color.fromARGB(255, 190, 144, 245),
    );
  }
}

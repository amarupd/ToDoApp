// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 100, 171),
        title: const Center(child:  Text("LOGOUT PAGE",style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),)),
      ),
    );
  }
}
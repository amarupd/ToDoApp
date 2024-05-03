// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  //text editing controller
  TextEditingController myController = TextEditingController();
  String greetingMessage = '';
  void greeet() {
    String username = myController.text;

    setState(() {
      greetingMessage = "Hello, " + username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //greeeting message for user
              Text(
                greetingMessage,
                style: TextStyle(
                    fontFamily: 'IndieFlower',
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 71, 20, 4),
                    fontSize: 30.0),
              ),

              TextField(
                controller: myController,
                style: TextStyle(
                    fontFamily: 'IndieFlower',
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    fontSize: 20.0),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter you text here....",
                    hintStyle: TextStyle(
                        fontFamily: 'IndieFlower',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
              ),
              ElevatedButton(onPressed: greeet, child: Text("tap"))
            ],
          ),
        ),
      ),
    );
  }
}

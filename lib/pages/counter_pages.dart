// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter=0;

  void _incrementCounter(){
    setState(() {
          _counter++;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("you have pressed the button"),
            Text(_counter.toString(),
            style: TextStyle(
              fontSize: 40.0
            ),),
            //button
            // ignore: sort_child_properties_last
            ElevatedButton(onPressed: _incrementCounter, child: Text("Increment!"),style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 155, 190, 252)),
            ),)
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 175, 189, 169),
    );
  }
}

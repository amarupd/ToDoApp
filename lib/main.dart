// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/pages/to_do.dart';

void main() async {
  //init the hive
  await Hive.initFlutter();

  var box=await Hive.openBox('mybox');

  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDo(),
      routes: {
        '/todolist': (context) =>ToDo()
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

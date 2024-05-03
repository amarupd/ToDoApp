// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todoapp/util/my_button.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  final bool isEdit;
  final String? initialText;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.isEdit,
    this.initialText, // Receive the initial text
  }) {
    controller.text = initialText ?? ''; // Set the initial text to the controller
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.cyan[300],
      content: SizedBox(
        // height: 150,
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                // child: TextField(
                //   controller: controller,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide.none, // Remove border
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     hintText: "Add new task....",
                //     hintStyle: TextStyle(color: Colors.grey),
                //   ),
                // ),
                child: TextField(
                    controller: controller,
                    maxLines: 5, // Allow the TextField to expand vertically
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Add new task....",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
              ),
          
              //add button and delete button
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(text: isEdit ? "UPDATE" : "SAVE", onPressed: onSave),
                    const SizedBox(width: 8.0),
                    MyButton(text: "CANCEL", onPressed: onCancel)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

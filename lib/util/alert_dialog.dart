// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todoapp/util/my_button.dart';

class AlertDialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller; // Consider specifying the type of controller
  final VoidCallback onDelete; // Specify the type for callbacks
  final VoidCallback onCancel; // Specify the type for callbacks

  const AlertDialogBox({
    super.key,
    required this.controller,
    required this.onDelete,
    required this.onCancel,
  });

  @override
   Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete?"), // Updated title
      backgroundColor: const Color.fromARGB(255, 172, 224, 231),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensure the dialog fits its content
        children: [
          Text(
            "Are you sure you want to delete?",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30), // Add space between text and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(text: "CANCEL", onPressed: onCancel),
              SizedBox(width: 8.0), // Add some spacing between buttons
              MyButton(text: "DELETE", onPressed: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

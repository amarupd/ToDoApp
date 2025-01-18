// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/pages/pdf_compressor.dart';
import 'package:todoapp/util/alert_dialog.dart';
import 'package:todoapp/util/dialog_box.dart';
import 'package:todoapp/util/todo_tile.dart';


class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  // Reference the Hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void updateTask(int index, String newText) {
    setState(() {
      db.toDoList[index][0] = newText;
    });
    db.updateData();
    Navigator.of(context).pop();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    db.updateData();
    Navigator.of(context).pop();
  }

  void alertButton(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogBox(
            controller: _controller,
            onDelete: () => deleteTask(index),
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void cancelNewTask() {
    setState(() {
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller: _controller,
              onSave: saveNewTask,
              onCancel: cancelNewTask,
              isEdit: false);
        });
  }

  void editTask(int index) {
    String currentTaskName = db.toDoList[index][0];
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () => updateTask(index, _controller.text),
          onCancel: () => Navigator.of(context).pop(),
          isEdit: true,
          initialText: currentTaskName,
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
    Navigator.of(context).pop();
  }


  void compressPDF() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PDFCompressorPage()),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 252, 249),
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        elevation: 0,
        title: Center(
          child: Text(
            "ToDo List",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "IndieFlower",
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Swipe Instructions"),
                  content: Text("Swipe left to delete, swipe right to edit."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 20,
            left: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: compressPDF,
              child: Icon(
                Icons.picture_as_pdf,
                size: 35,
                color: Colors.white,
              ),
              tooltip: "Compress PDF",
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.teal[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: createNewTask,
              child: Icon(
                Icons.add,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: db.toDoList.isNotEmpty
          ? ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => alertButton(index),
                  updateData: (value) => editTask(index),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Text(
                  "Click on the + button to add a new task.",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
    );
  }
}

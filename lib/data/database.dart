import 'package:hive/hive.dart';

class ToDoDataBase {
  //reference the box
  List toDoList=[];

  final _myBox=Hive.box('mybox');

  void createInitialData(){
    toDoList=[];
  }

  void loadData(){
    toDoList=_myBox.get("TODOLIST");
  }

  void updateData(){
    _myBox.put("TODOLIST",toDoList);
  }
}
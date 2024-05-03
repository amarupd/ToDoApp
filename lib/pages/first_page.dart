// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todoapp/pages/counter_pages.dart';
import 'package:todoapp/pages/to_do.dart';
import 'package:todoapp/pages/user_input.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [ToDo(), UserInput(), CounterPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("First page")),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 134, 69, 247),
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                "Hi Amar",
                style: TextStyle(
                    color: Colors.amber,
                    fontFamily: 'IndieFlower',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            //1st
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.amber,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/homepage');
              },
            ),
            // 2nd
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.amber,
              ),
              title: Text(
                "Setting",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settingspage');
              },
            ),

            //3rd
            ListTile(
              leading: Icon(
                Icons.face_6_rounded,
                color: Colors.amber,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),

            // 4th
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.amber,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/logout');
              },
            ),

            ListTile(
              leading: Icon(
                Icons.book,
                color: Colors.amber,
              ),
              title: Text(
                "TODO",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/todolist');
              },
            ),
          ],
        ),
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromARGB(255, 236, 236, 255),
        onTap: _navigateBottomBar,
        fixedColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "TODO",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "CHAT"),
          // BottomNavigationBarItem(icon: Icon(Icons.settings), label: "SETTING"),
          BottomNavigationBarItem(icon: Icon(Icons.countertops), label: "COUNTER"),
        ],
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     child: const Text("Go to 2nd page"),
      //     onPressed: () {
      //       Navigator.pushNamed(context, '/homepage');
      //     },
      //   ),
      // ),
    );
  }
}

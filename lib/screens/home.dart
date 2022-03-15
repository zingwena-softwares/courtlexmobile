import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/cases.dart';
import 'package:courtlexmobile/screens/clients.dart';
import 'package:courtlexmobile/screens/notes.dart';
import 'package:courtlexmobile/screens/schedules.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title, required this.user})
      : super(key: key);
  final String title;
  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active_outlined),
            onPressed: () {},
          )
        ],
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Courtlex Diary Features",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 25),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Clients()),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.red,
                            ),
                            Text(
                              "Clients",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Cases()),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_sharp,
                              color: Colors.indigo,
                            ),
                            Text(
                              "Cases",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Schedules()),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              "Schedule",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Notes()),
                      );
                    },
                    splashColor: Colors.blueGrey,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              color: Colors.lightBlueAccent,
                            ),
                            Text(
                              "Notes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.red,
                            ),
                            Text(
                              "Calendar",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_sharp,
                              color: Colors.indigo,
                            ),
                            Text(
                              "Messages",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      debugPrint("yes ");
                    },
                    splashColor: Colors.blueGrey,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.grey,
                            ),
                            Text(
                              "Settings",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint("yes ");
                    },
                    splashColor: Colors.blueGrey,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_sharp,
                              color: Colors.green,
                            ),
                            Text(
                              "Calls",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Status Overview",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 25),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        height: 90.0,
                        width: 90.0,
                        child: Card(
                          semanticContainer: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "1",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 30.0),
                              ),
                              Text(
                                "Open",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                              Text(
                                "Cases",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: 90.0,
                        width: 90.0,
                        child: Card(
                          semanticContainer: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "1",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 30.0),
                              ),
                              Text(
                                "Schedule",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                              Text(
                                "Today",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        debugPrint("yes ");
                      },
                      splashColor: Colors.blueGrey,
                      child: Container(
                        height: 90.0,
                        width: 90.0,
                        child: Card(
                          semanticContainer: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "1",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 30.0),
                              ),
                              Text(
                                "Clients",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                "Added",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      debugPrint("yes");
                    },
                    splashColor: Colors.blueGrey,
                    child: Container(
                      height: 90.0,
                      width: 90.0,
                      child: Card(
                        semanticContainer: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "1",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 30.0),
                            ),
                            Text(
                              "Cases",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                            Text(
                              "Added",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey.shade200,
          //other styles
        ),
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Row(
                    children: [
                      Text('${widget.user.name}'),
                      SizedBox(
                        width: 10,
                      ),
                      Text('${widget.user.surname}'),
                    ],
                  ),
                  accountEmail: Text('${widget.user.email}'),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.people_alt,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Clients",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Clients()),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.cases,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Cases",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Cases()),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Schedules",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Schedules()),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.notes,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Notes",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Notes()),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Calendar",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Messages",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                Divider(color: Colors.black87),
                ListTile(
                  title: Text(
                    "Other Information",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade800,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "About Us",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  title: Text(
                    "Share App",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                        fontSize: 16),
                  ),
                ),
                ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600,
                          fontSize: 16),
                    ),
                    onTap: () {
                      logout().then((value) => {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                (route) => false)
                          });
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
              color: Colors.grey,
            ),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Colors.grey),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.grey),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gql/screens/add_user_page.dart';
import 'package:flutter_gql/screens/users_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content = UsersPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users & Hobbies",
          style: TextStyle(
              color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(child: content),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route = MaterialPageRoute(
            builder: (context) => AddUserPage(),
          );
          await Navigator.push(context, route);
        },
        backgroundColor: Colors.lightGreen,
        child: Icon(Icons.group_add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

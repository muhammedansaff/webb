import 'package:admin/login/login.dart';
import 'package:admin/pages/addposts.dart';
import 'package:admin/pages/allworkers.dart';
import 'package:admin/pages/complains.dart';
import 'package:admin/pages/feedbacks.dart';
import 'package:admin/pages/userrequest.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context); // Pass the context here
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.jpg"),
          ),
          DrawerListTile(
            title: "workers requests",
            icon: Icons.person,
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserRequests()));
            },
          ),
          DrawerListTile(
            title: "all workers",
            icon: Icons.work,
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WorkersList()));
            },
          ),
          DrawerListTile(
            icon: Icons.upload,
            title: "Upload posts",
            press: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPosts()));
            },
          ),
          DrawerListTile(
            icon: Icons.feedback,
            title: "feedbacks",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => feedBacks()));
            },
          ),
          DrawerListTile(
            icon: Icons.error_sharp,
            title: "complaints",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Complains()));
            },
          ),
          DrawerListTile(
            icon: Icons.logout,
            title: "logout",
            press: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

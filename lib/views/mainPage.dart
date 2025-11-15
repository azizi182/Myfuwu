import 'package:flutter/material.dart';
//import 'package:myfuwu_project/registerPage.dart';
import 'package:myfuwu_project/views/loginPage.dart';
import 'package:myfuwu_project/models/user.dart';
import 'package:myfuwu_project/views/servicePage.dart';

class Mainpage extends StatefulWidget {
  final User? user;

  const Mainpage({super.key, required this.user});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(
        child: Column(
          children: [
            Text('User ID: ${widget.user?.userId}'),
            Text('User Email: ${widget.user?.userEmail}'),
            Text('User Name: ${widget.user?.userName}'),
            Text('User Phone: ${widget.user?.userPhone}'),
            Text('User Password: ${widget.user?.userPassword}'),
            Text('User OTP: ${widget.user?.userOtp}'),
            Text('User Regdate: ${widget.user?.userRegdate}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the button
          if (widget.user?.userId == '0') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please login first/or register first"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Loginpage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyServicePage(user: widget.user),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myfuwu_project/models/user.dart';
import 'package:myfuwu_project/shared/animated_route.dart';
import 'package:myfuwu_project/views/loginPage.dart';
import 'package:myfuwu_project/views/mainPage.dart';
import 'package:myfuwu_project/views/ownServicePage.dart';

class Mydrawer extends StatefulWidget {
  final User? user;
  const Mydrawer({super.key, required this.user});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user?.userName.toString() ?? 'Guest'),
            accountEmail: Text(widget.user?.userEmail.toString() ?? 'Guest'),
            currentAccountPicture: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/myfuwu_logo.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainPage(user: widget.user)),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.add_box_outlined),
            title: Text('My services'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(Ownservicepage(user: widget.user)),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Loginpage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

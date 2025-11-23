import 'package:flutter/material.dart';
import 'package:myfuwu_project/models/user.dart';

class Ownservicepage extends StatefulWidget {
  final User? user;
  const Ownservicepage({super.key, required this.user});

  @override
  State<Ownservicepage> createState() => _OwnservicepageState();
}

class _OwnservicepageState extends State<Ownservicepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Own Service Page')),
      body: Center(child: Text('This is the Own Service Page')),
    );
  }
}

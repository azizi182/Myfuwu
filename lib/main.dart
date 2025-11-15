import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu_project/views/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfuwu_project/models/user.dart';
import 'package:myfuwu_project/views/ipAddress.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}

//class splashscreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email = '';
  String password = '';
  String name = '';
  String phone = "";

  @override
  void initState() {
    super.initState();
    autologin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/myfuwu_logo.jpg',
              width: 150,
              height: 150,
            ), //scale:1,2,3,4
            Text(
              'MyFuwuProject',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http
            .post(
              Uri.parse('${MyConfig.baseUrl}/myfuwu/api/login.php'),
              body: {
                'email': email,
                'password': password,
                'name': name,
                'phone': phone,
              },
            )
            .then((response) {
              if (response.statusCode == 200) {
                var jsonResponse = response.body;
                // print(jsonResponse);
                var resarray = jsonDecode(jsonResponse);
                if (resarray['status'] == 'success') {
                  //print(resarray['data'][0]);
                  User user = User.fromJson(resarray['data'][0]);
                  if (!mounted) return;
                  Future.delayed(Duration(seconds: 2), () {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mainpage(user: user),
                      ),
                    );
                  });
                } else {
                  Future.delayed(Duration(seconds: 3), () {
                    if (!mounted) return;
                    User user = User(
                      userId: '0',
                      userEmail: 'guest@email.com',
                      userName: 'guest',
                      userPhone: 'guest',
                      userPassword: 'guest',
                      userOtp: '0000',
                      userRegdate: '0000-00-00',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mainpage(user: user),
                      ),
                    );
                  });
                }
              } else {
                Future.delayed(Duration(seconds: 3), () {
                  if (!mounted) return;
                  User user = User(
                    userId: '0',
                    userEmail: 'guest@email.com',
                    userPassword: 'guest',
                    userName: 'guest',
                    userPhone: 'guest',
                    userOtp: '0000',
                    userRegdate: '0000-00-00',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Mainpage(user: user),
                    ),
                  );
                });
              }
            });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          if (!mounted) return;
          User user = User(
            userId: '0',
            userEmail: 'guest@email.com',
            userPassword: 'guest',
            userName: 'guest',
            userPhone: 'guest',
            userOtp: '0000',
            userRegdate: '0000-00-00',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mainpage(user: user)),
          );
        });
      }
    });
  }
}

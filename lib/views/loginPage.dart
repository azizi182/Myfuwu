import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfuwu_project/views/mainPage.dart';
import 'package:myfuwu_project/views/registerPage.dart';
import 'package:myfuwu_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfuwu_project/views/ipAddress.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late double screenHeight, screenWidth;
  bool visible = true;
  bool loading = false;
  bool checkBox = false;
  late User user;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(
      context,
    ).size.height; // mediaquery -  that adapt to various screen sizes.
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      // 600 pixel is a for mobile.
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    print(screenWidth);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text('Login Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
            child: SizedBox(
              width: screenWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/myfuwu_logo.jpg', scale: 3),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (visible) {
                            visible = false;
                          } else {
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Remember Me"),
                      Checkbox(
                        value: checkBox,
                        onChanged: (value) {
                          // value is time press
                          checkBox = value!;
                          setState(() {});
                          if (checkBox) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              prefUpdate(checkBox);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Preference stored!",
                                    style: TextStyle(color: Colors.black),
                                  ),

                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    13,
                                    141,
                                    109,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please fill in all the fields.",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                          } else {
                            prefUpdate(checkBox);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Preferences Removed!"),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  141,
                                  13,
                                  56,
                                ),
                              ),
                            );
                            emailController.clear();
                            passwordController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(onPressed: loginDialog, child: Text("Login")),
                  SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registerpage()),
                      );
                    },
                    child: Text("Already have an account? Login"),
                  ),

                  Text("Forgot Password?"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginDialog() {
    String email = emailController.text;
    String password = passwordController.text;

    // Check if the user has filled in all the fields
    if (email.isEmpty || password.isEmpty) {
      SnackBar snackBar = SnackBar(
        // pop message on the bottom of the screen
        content: Text("Please fill in all the fields."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Check if the email address is valid
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      SnackBar snackBar = SnackBar(
        content: Text("Please enter a valid email address."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Show a dialog to ask the user if they are sure to login
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login this account?"),
        content: Text("Are you sure you want to login this account?"),
        actions: [
          TextButton(
            onPressed: () => {loginUser(), Navigator.pop(context)},
            child: Text("Login"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/myfuwu/api/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          print("Response body: ${response.body}");
          if (response.statusCode == 200) {
            var jsonResponse = response.body;

            var resarray = jsonDecode(
              jsonResponse,
            ); // php return in json type so have translate into array

            if (resarray['status'] == 'success' && resarray['data'] != null) {
              //print(resarray['data'][0]);
              user = User.fromJson(resarray['data'][0]);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              // Navigate to home page or dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Mainpage(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // Handle successful login here
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  Future<void> prefUpdate(bool checkBox) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (checkBox) {
      // store email and password to remember.
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', checkBox);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        checkBox = true;
        setState(() {});
      }
    });
  }
}

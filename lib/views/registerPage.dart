import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu_project/views/ipAddress.dart';
import 'package:myfuwu_project/views/loginPage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  late double screenHeight, screenWidth;
  bool visible = true;
  bool loading = false;
  String address = "";

  late Position mypostion;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
      appBar: AppBar(title: Text('Register Page'), actions: [
          
        ],
      ),

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
                    controller: nameController,
                    //obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    //obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    maxLines: 3,
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          mypostion = await _determinePosition();
                          print(mypostion.latitude);
                          print(mypostion.longitude);
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                mypostion.latitude,
                                mypostion.longitude,
                              );
                          Placemark place = placemarks[0];
                          addressController.text =
                              "${place.name},\n${place.street},\n${place.postalCode},${place.locality},\n${place.administrativeArea},${place.country}";
                          setState(() {});
                        },
                        icon: Icon(Icons.location_on),
                      ),
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

                  TextField(
                    controller: confirmPasswordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                    children: [],
                  ),
                  ElevatedButton(
                    onPressed: registerDialog,
                    child: Text("Register"),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                      );
                    },
                    child: Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerDialog() {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text;
    String phone = phoneController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      SnackBar snackBar = SnackBar(
        // pop message on the bottom of the screen
        content: Text("Please fill in all the fields."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password != confirmPassword) {
      SnackBar snackBar = SnackBar(content: Text("Passwords do not match."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      SnackBar snackBar = SnackBar(
        content: Text("Please enter a valid email address."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //check textfield
    if (addressController.text.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter an address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (mypostion.latitude.isNaN || mypostion.longitude.isNaN) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please select an address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Register this account?"),
        content: Text("Are you sure you want to register this account?"),
        actions: [
          TextButton(
            onPressed: () => {
              registerUser(email, password, name, phone),
              Navigator.pop(context),
            },
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void registerUser(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    setState(() {
      loading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Registering..."),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
    //print("registering user... $email, $password");
    // database server

    await http // wait to the complete first , to avoid crash.
        .post(
          // to post data to backend
          Uri.parse("${MyConfig.baseUrl}/api/register_user.php"),
          body: {
            "name": name,
            "phone": phone,
            "email": email, // parameters to send to backend
            "password": password,
            "address": addressController.text,
            "latitude": mypostion.latitude.toString(),
            "longitude": mypostion.longitude.toString(),
          },
        )
        .then((response) {
          // body at the response from backend
          if (response.statusCode == 200) {
            //200 means ok
            var jsonResponse = response.body;
            var msgArray = jsonDecode(
              jsonResponse,
            ); // convert from json type(backend) to array msg (frontend)
            log(jsonResponse);
            // the array yg nak check.
            if (msgArray['status'] == "success") {
              if (!mounted) return;
              SnackBar snackBar = const SnackBar(
                content: Text("Register successful."),
              );

              if (loading) {
                if (!mounted) return;
                Navigator.pop(context); //pop the loading dialog
                setState(() {
                  loading = false;
                });
              }
              Navigator.pop(context); // close the register page
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Loginpage()),
              );
              //print("data dah masuk database");
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(msgArray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text("Error during registration. Please try again."),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          // happen server crash or no response
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text("Request timed out. Please try again."),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );
    if (loading) {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        loading = false;
      });
    }
  }
}

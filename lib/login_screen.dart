import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:practical_app/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  bool isVisible = false;
  bool isLoading = false;

  Future<void> login() async {
    final response = await http.post(Uri.parse("https://dummyjson.com/auth/login"),
      body: json.encode({
        'username': username.text,  // use this username: 'kminchelle',
        'password': password.text,  // use this password: '0lelplR',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyDashboard(tokenMap: jsonData)),
      );
      Fluttertoast.showToast(
        msg: 'Login Successful',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid username and password"),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Login Now",
                  style: TextStyle(fontSize: 30, color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Enter UserName',
                            labelText: 'UserName',
                            prefixIcon: const Icon(Icons.person, color: Colors.purple,),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter UserName";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Colors.purple,),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.purple,),
                            )
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password";
                            }
                            return null;
                          },
                          obscureText: !isVisible,
                        ),
                        const SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: () async{
                            if (formKey.currentState!.validate()) {
                              await login();
                            }
                            setState(() {
                              isLoading = !isLoading;
                            });
                          }, 
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.4)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          child:  isLoading
                                ? const CircularProgressIndicator(color: Colors.white,) // Show CircularProgressIndicator when isLoading is true
                                : const Text("Login", style: TextStyle(fontSize: 16))
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

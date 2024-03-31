import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key, required this.userMap});

  final Map<String, dynamic> userMap;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  Future<Map<String, dynamic>> getAuthUser() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.userMap['token']}', 
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> authData = json.decode(response.body);
      return authData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAuthUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('Suraj: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final user = snapshot.data!;
            return Center(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: Column(
                      children: [
                        Material(
                          borderRadius: const BorderRadius.all(Radius.circular(80)),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              height: 160,
                              width: 160,
                              child: CircleAvatar(
                                backgroundColor: Colors.purple,
                                backgroundImage: NetworkImage(user['image']),
                                radius: 50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text('${user['firstName']} ${user['lastName']}',
                          style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Train"),
                        ),
                        const SizedBox(height: 5,),
                        Text(user['phone'],
                          style: const TextStyle(color: Colors.blue, fontSize: 20, fontFamily: "Train"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),

                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Divider(
                          height: 10,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.purple,),
                          title: const Text(
                            "Email",
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(user['email'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: ()
                          {
                            
                          },
                        ),
                        const Divider(
                          height: 10,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.purple,),
                          title: const Text(
                            "Address",
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text('${user['address']['address']}, ${user['address']['city']}, ${user['address']['state']}, ${user['address']['postalCode']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: ()
                          {
                            
                          },
                        ),
                        const Divider(
                          height: 10,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings, color: Colors.purple,),
                          title: const Text(
                            "Settings",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: ()
                          {

                          },
                        ),
                        const Divider(
                          height: 10,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
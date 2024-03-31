import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practical_app/update_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _dummyUsers;

  @override
  void initState() {
    super.initState();
    _dummyUsers = getUsers();
  }

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/users"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> usersList = jsonData['users'];
      return usersList;
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> updatedUserData) async {
    final response = await http.put(Uri.parse("https://dummyjson.com/users/$userId"),
      body: json.encode(updatedUserData),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse("https://dummyjson.com/users/$userId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _dummyUsers,
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
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['image']),
                    backgroundColor: Colors.grey, 
                  ),
                  title: Text('${user['firstName']} ${user['lastName']}'),
                  subtitle: Text(user['email']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return UpdateDialog(
                                  userId: user['id'], 
                                  selectedUser: updateUser,
                                );
                              }
                            );
                          }
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async{
                            await deleteUser(user['id']);
                            setState(() {}); // Refresh the UI
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User deleted Successfully')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () { 

                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

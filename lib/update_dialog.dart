import 'package:flutter/material.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key, required this.userId, required this.selectedUser});

  final int userId;
  final Function(int, Map<String, dynamic>) selectedUser;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {

  final _firstName = TextEditingController();
  final _email = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Map<String, dynamic> updatedUserData = {
              'firstName': _firstName.text,
              'email': _email.text,
            };
            // Call updateUser method from HomeScreen
            widget.selectedUser(widget.userId, updatedUserData);
            // Close the dialog
            Navigator.pop(context);
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User data updated Successfully')),
            );
          },
          child: const Text("Update"),
        ),
      ],
      title: const Text("Update User"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _firstName,
            validator: (value) {
              if (value!.isEmpty) {
                return "FirstName is required";
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text("FirstName"),
            ),
          ),
          TextFormField(
            controller: _email,
            validator: (value) {
              if (value!.isEmpty) {
                return "Email is required";
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
          ),
        ]
      ),
    );
  }
}
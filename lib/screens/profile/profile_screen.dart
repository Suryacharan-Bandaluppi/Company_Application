import 'dart:io';
import 'package:flutter/material.dart';
import 'package:generic_company_application/services/local_storage.dart';
import 'package:generic_company_application/utils/helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final storedUsername = await LocalStorage.getUsername();
    final storedEmail = await LocalStorage.getEmail();

    if (!mounted) return;

    setState(() {
      username = storedUsername;
      email = storedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Profile")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : null,
                    child: profileImage == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username ?? "UserName",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email ?? "email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      final image = await Helpers.showProfilePhotoOptions(
                        context,
                      );
                      if (image != null) {
                        setState(() {
                          profileImage = image;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

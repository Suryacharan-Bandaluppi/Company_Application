import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileEditDailog extends StatefulWidget {
  final String username;
  final String email;
  const ProfileEditDailog({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<ProfileEditDailog> createState() => _ProfileEditDailogState();
}

class _ProfileEditDailogState extends State<ProfileEditDailog> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: userNameController,
            decoration: const InputDecoration(labelText: "User Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}

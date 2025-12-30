import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/services/user_service.dart';
import 'package:generic_company_application/utils/helpers.dart';
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
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            final newName = userNameController.text.trim();

            try {
              await UserService.instance.updateUserProfile(
                userId: FirebaseAuth.instance.currentUser!.uid,
                name: newName,
                email: emailController.text,
              );
              context.pop(true);
              Helpers.showSuccessSnackbar(
                context,
                "UserName Updated Successfully",
              );
            } catch (e) {
              Helpers.showSuccessSnackbar(
                context,
                "Error in Updating Profile $e",
              );
            }
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}

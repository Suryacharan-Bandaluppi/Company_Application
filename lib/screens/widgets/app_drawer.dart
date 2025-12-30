import 'package:flutter/material.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:generic_company_application/screens/widgets/profile_edit_dailog.dart';
import 'package:generic_company_application/services/local_storage.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {
  final VoidCallback logout;
  final VoidCallback delete;
  const AppDrawer({super.key, required this.logout, required this.delete});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // User user = FirebaseAuth.instance.currentUser!;
  // String get userId => user.uid;
  // String get name => user.displayName ?? "UserName";
  // String get email => user.email ?? "email";

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
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            color: Theme.of(context).primaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 150),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? "UserName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email ?? "Email",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    context.pop();
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ProfileEditDailog(
                        username: username ?? "UserName",
                        email: email ?? "Email",
                      ),
                    );
                    if (result == true) {
                      _loadUser();
                    }
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(title: "Posts", value: "5"),
                _StatItem(title: "Concerns", value: "3"),
              ],
            ),
          ),

          const Divider(),

          /// YOUR POSTS
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text("Posts"),
            onTap: () {
              context.push(AppRoutes.currentUserPosts);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Concerns"),
            onTap: () {
              context.push(AppRoutes.viewConcerns);
            },
          ),

          const Spacer(),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              widget.logout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Profile"),
                  content: Text(
                    "Are you sure!!! This will permanently delete your account",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.delete();
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "App Version 1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

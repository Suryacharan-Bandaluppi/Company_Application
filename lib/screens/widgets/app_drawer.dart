import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  // final user2 = FirebaseAuth.instance.currentUser?.email ?? "User";

  User user = FirebaseAuth.instance.currentUser!;
  String get name => user.displayName ?? "UserName";
  String get email => user.email ?? "email";
  final VoidCallback logout;
  AppDrawer({super.key, required this.logout});

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
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    context.pop();
                    context.push(AppRoutes.profile);
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
              children: const [
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
              logout();
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

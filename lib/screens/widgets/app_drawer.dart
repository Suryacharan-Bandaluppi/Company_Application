import 'package:flutter/material.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:generic_company_application/screens/widgets/profile_edit_dailog.dart';
import 'package:generic_company_application/services/issue_post_service.dart';
import 'package:generic_company_application/services/local_storage.dart';
import 'package:generic_company_application/services/post_service.dart';
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
  late Future<Map<String, int>> _countsFuture;

  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCounts();
  }

  void _loadCounts() {
    _countsFuture = Future.wait([
      postService.getCurrentUserPostCount(),
      IssuePostService.instance.getIssueCountForCurrentUser(),
    ]).then((values) => {'posts': values[0], 'issues': values[1]});
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
            child: FutureBuilder<Map<String, int>>(
              future: _countsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  );
                }

                if (!snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text("0", style: TextStyle(fontSize: 18)),
                      Text("0", style: TextStyle(fontSize: 18)),
                    ],
                  );
                }

                final counts = snapshot.data!;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          counts['posts'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Posts",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          counts['issues'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Concerns",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(),

          /// YOUR POSTS
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text("Posts"),
            onTap: () {
              context.pop();
              context.push(AppRoutes.currentUserPosts);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Concerns"),
            onTap: () {
              context.pop();
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

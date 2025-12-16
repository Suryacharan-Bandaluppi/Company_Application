import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/screens/home_screen.dart';
import 'package:generic_company_application/screens/post_screens/add_post_screen.dart';
import 'package:generic_company_application/screens/post_screens/post_card.dart';
import 'package:generic_company_application/services/auth_service.dart';
import 'package:generic_company_application/services/post_service.dart';

class PostsViewScreen extends StatefulWidget {
  const PostsViewScreen({super.key});

  @override
  State<PostsViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostsViewScreen> {
  void logoutbutton() async {
    final authService = AuthService();
    authService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts ViewScreen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Add Post',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AddPostScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              logoutbutton();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: PostService().getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
    );
  }
}

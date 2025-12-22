import 'dart:io';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/screens/post_screens/post_card.dart';
import 'package:generic_company_application/services/post_service.dart';

class CurrentUserPostsViewScreen extends StatefulWidget {
  const CurrentUserPostsViewScreen({super.key});
  @override
  State<CurrentUserPostsViewScreen> createState() =>
      _CurrentUserPostsViewScreenState();
}

class _CurrentUserPostsViewScreenState
    extends State<CurrentUserPostsViewScreen> {
  File? profileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Posts")),
      body: StreamBuilder<List<PostModel>>(
        stream: postService.getCurrentUserPosts(),
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
              return PostCard(
                post: posts[index],
                enableEditButton: true,
                enableLikeButton: false,
                enableDeleteButton: true,
              );
            },
          );
        },
      ),
    );
  }
}

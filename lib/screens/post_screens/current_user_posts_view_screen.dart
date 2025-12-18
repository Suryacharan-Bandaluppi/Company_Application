import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/screens/post_screens/post_card.dart';
import 'package:generic_company_application/screens/utils/helpers.dart';
import 'package:generic_company_application/services/post_service.dart';

class CurrentUserPostsViewScreen extends StatefulWidget {
  // final File? profileImage;
  final user = FirebaseAuth.instance.currentUser?.email ?? "User";
  CurrentUserPostsViewScreen({super.key});
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
                        widget.user,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Public", style: TextStyle(color: Colors.grey)),
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
          SizedBox(height: 20),
          Text(
            "Your Recent Posts",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: StreamBuilder<List<PostModel>>(
              stream: PostService().getcurrentuserPosts(),
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
          ),
        ],
      ),
    );
  }
}

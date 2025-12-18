import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/screens/utils/helpers.dart';
import 'package:generic_company_application/services/post_service.dart';

class AddPostScreen extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser?.email ?? "User";
  AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController createTextController = TextEditingController();
  final TextEditingController titleTextController = TextEditingController();

  @override
  void dispose() {
    createTextController.dispose();
    titleTextController.dispose();
    super.dispose();
  }

  void postContent() async {
    if (createTextController.text.trim().isEmpty ||
        titleTextController.text.trim().isEmpty)
      return;

    await PostService().addPost(
      title: titleTextController.text.trim(),
      content: createTextController.text.trim(),
    );

    createTextController.clear();
    titleTextController.clear();
    Helpers.showSuccessSnackbar(context, "Post added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              /// USER INFO CARD
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 22, child: Icon(Icons.person)),
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
                    ],
                  ),
                ),
              ),

              ///Title Card
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: titleTextController,
                    decoration: const InputDecoration(
                      hintText: "Title of the Post",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              /// POST INPUT CARD
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: createTextController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              /// ADD TO POST OPTIONS
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add to your post",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.image, size: 28, color: Colors.green),
                          SizedBox(width: 12),
                          Icon(
                            Icons.video_collection,
                            size: 28,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 150),

              /// POST BUTTON
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: postContent,
                  child: const Text("Post", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/screens/widgets/edit_post_dailog.dart';
import 'package:generic_company_application/services/post_service.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool enableEditButton;
  final bool enableDeleteButton;
  final bool enableLikeButton;
  const PostCard({
    super.key,
    required this.post,
    this.enableEditButton = false,
    this.enableDeleteButton = false,
    this.enableLikeButton = true,
  });
  @override
  Widget build(BuildContext context) {
    int timestamp = post.timeCreated;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = "${date.month}/${date.day}/${date.year}";

    void _confirmDelete(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await PostService().deletePost(post.id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER HEADER
            Row(
              children: [
                const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.createdUser.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                if (enableDeleteButton)
                  IconButton(
                    onPressed: () {
                      _confirmDelete(context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                if (enableEditButton)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditPostDialog(post: post),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            /// POST TITLE
            Text(
              post.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            /// POST CONTENT
            Text(post.content, style: TextStyle(fontSize: 14)),

            const SizedBox(height: 10),

            /// IMAGE (Optional)
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.network(
            //     "https://picsum.photos/500/300",
            //     height: 180,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),

            // const SizedBox(height: 10),

            /// LIKE & COMMENT COUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("👍 ${post.likes}"), Text("💬 3 Comments")],
            ),

            const Divider(height: 20),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (enableLikeButton) ...[
                  PostAction(icon: Icons.thumb_up_alt_outlined, label: "Like"),
                ],
                PostAction(icon: Icons.comment_outlined, label: "Comment"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Action Button
class PostAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const PostAction({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 20), const SizedBox(width: 6), Text(label)],
    );
  }
}

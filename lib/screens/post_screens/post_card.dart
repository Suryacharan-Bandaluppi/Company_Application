import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/utils/helpers.dart';
import 'package:generic_company_application/screens/widgets/edit_post_dailog.dart';
import 'package:generic_company_application/services/post_service.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatefulWidget {
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
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    int timestamp = widget.post.timeCreated;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = "${date.day}/${date.month}/${date.year}";

    void confirmDelete(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await postService.deletePost(widget.post.id);
                context.pop();
                Helpers.showSuccessSnackbar(
                  context,
                  "Post Deleted Successfully",
                );
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
                      widget.post.createdUser.name,
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
                if (widget.enableDeleteButton)
                  IconButton(
                    onPressed: () {
                      confirmDelete(context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                if (widget.enableEditButton)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditPostDialog(post: widget.post),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            /// POST TITLE
            Text(
              widget.post.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            /// POST CONTENT
            Text(widget.post.content, style: TextStyle(fontSize: 14)),

            const SizedBox(height: 10),

            // //IMAGE (Optional)
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.network(
            //     "https://picsum.photos/500/300",
            //     height: 180,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(height: 10),

            /// LIKE & COMMENT COUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("👍 5 Likes"), Text("💬 3 Comments")],
            ),

            const Divider(height: 20),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.enableLikeButton) ...[
                  TextButton.icon(
                    onPressed: () {},
                    label: Text("Like"),
                    icon: Icon(Icons.thumb_up_alt_rounded, size: 20),
                  ),
                ],
                TextButton.icon(
                  onPressed: () {},
                  label: Text("Comment"),
                  icon: Icon(Icons.comment_outlined, size: 20),
                ),
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

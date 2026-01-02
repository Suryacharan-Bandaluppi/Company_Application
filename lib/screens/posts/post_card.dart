import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/screens/widgets/comments_bottom_sheet.dart';
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
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    int timestamp = widget.post.timeCreated;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = "${date.day}-${date.month}-${date.year}";
    bool isLiked = widget.post.likes.containsKey(currentUserId);
    int likeCount = widget.post.likes.length;
    int commentCount = widget.post.comments.length;

    void confirmDelete(BuildContext context) {
      showDialog(
        barrierDismissible: false,
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
                context.pop();
                Helpers.showSuccessSnackbar(
                  context,
                  "Post Deleted Successfully",
                );
                await postService.deletePost(widget.post.id);
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // StreamBuilder<AppUser>(
                    //   stream: UserService.instance.getUserByIdForPosts(
                    //     widget.post.createdUser.id,
                    //   ),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData) {
                    //       return const Text("Loading...");
                    //     }

                    //     final user = snapshot.data!;

                    //     return Text(
                    //       user.name,
                    //       style: const TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     );
                    //   },
                    // ),
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
                        barrierDismissible: false,
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

            const SizedBox(height: 10),

            /// LIKE & COMMENT COUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                likeCount == 1
                    ? Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            "$likeCount Like",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            "$likeCount Likes",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.comment,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      commentCount == 1
                          ? "$commentCount comment"
                          : "$commentCount comments",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 20),

            /// ACTION BUTTONS
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.enableLikeButton) ...[
                  IconButton(
                    onPressed: () async {
                      await postService.toggleLike(
                        postId: widget.post.id,
                        userId: currentUserId,
                        isLiked: isLiked,
                      );
                    },
                    // label: isLiked ? Text("Like") : Text("DisLike"),
                    icon: Icon(
                      color: Theme.of(context).colorScheme.primary,
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 25,
                    ),
                  ),
                ],
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // backgroundColor: Colors.transparent,
                      builder: (_) => CommentsBottomSheet(posts: widget.post),
                    );
                  },

                  icon: Icon(
                    color: Theme.of(context).colorScheme.primary,
                    Icons.comment_outlined,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/comment_model.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/services/post_service.dart';

class CommentsBottomSheet extends StatefulWidget {
  final PostModel posts;
  const CommentsBottomSheet({super.key, required this.posts});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  TextEditingController commentText = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  String get userId => user.uid;
  String get name => user.displayName ?? "UserName";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Title
              Text(
                "Comments",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Comment List
              Expanded(
                child: StreamBuilder<List<CommentModel>>(
                  stream: postService.getComments(widget.posts.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!;
                    if (comments.isEmpty) {
                      return Text(
                        "No comments yet",
                        style: theme.textTheme.bodySmall,
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            child: Text(
                              comment.userName[0].toUpperCase(),
                              style: TextStyle(color: colorScheme.onPrimary),
                            ),
                          ),
                          title: Text(
                            comment.userName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            comment.text,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: Text(
                            dateFormatting(
                              DateTime.fromMillisecondsSinceEpoch(
                                comment.createdAt,
                              ),
                            ),
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Input box
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentText,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.send, color: colorScheme.primary),
                      onPressed: () async {
                        if (commentText.text.trim().isEmpty) return;

                        await PostService().addComment(
                          postId: widget.posts.id,
                          userId: userId,
                          userName: name,
                          comment: commentText.text.trim(),
                        );
                        commentText.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String dateFormatting(DateTime date) {
  String formattedDate = "${date.day}-${date.month}-${date.year}";
  return formattedDate;
}

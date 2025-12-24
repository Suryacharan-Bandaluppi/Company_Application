import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/utils/helpers.dart';
import 'package:generic_company_application/services/post_service.dart';
import 'package:go_router/go_router.dart';

class EditPostDialog extends StatefulWidget {
  final PostModel post;

  const EditPostDialog({super.key, required this.post});

  @override
  State<EditPostDialog> createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post.title);
    contentController = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void updatePost() async {
    if (contentController.text.trim().isEmpty) return;

    await PostService().updatePost(
      postId: widget.post.id,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
    );

    context.pop();
    Helpers.showSuccessSnackbar(context, "Post Updated Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: contentController,
            maxLines: 4,
            decoration: const InputDecoration(labelText: "Content"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
        ElevatedButton(onPressed: updatePost, child: const Text("Update")),
      ],
    );
  }
}

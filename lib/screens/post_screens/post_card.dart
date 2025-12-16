import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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
                      post.timeCreated.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
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
              children: const [
                PostAction(icon: Icons.thumb_up_alt_outlined, label: "Like"),
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

// class PostCard extends StatelessWidget {
//   final PostModel post;

//   const PostCard({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(post.createdUser.name,
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text(post.title),
//             Text(post.content),
//             Text("👍 ${post.likes}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

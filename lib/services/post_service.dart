import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/post_model.dart';

class PostService {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref().child("posts");

  /// ADD POST
  Future<void> addPost({
    required String title,
    required String content,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final postId = _db.push().key!;

    final post = PostModel(
      id: postId,
      userId: user.uid,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      postType: "text",
      title: title,
      content: content,
      image: "",
      video: "",
      likes: 0,
      comments: [],
      createdUser: CreatedUser(
        id: user.uid,
        name: user.email ?? "User",
      ),
    );

    await _db.child(postId).set(post.toMap());
  }

  /// GET POSTS STREAM (REALTIME)
  Stream<List<PostModel>> getPosts() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.values
          .map((post) =>
              PostModel.fromMap(post as Map<dynamic, dynamic>))
          .toList()
        ..sort(
          (a, b) => b.timeCreated.compareTo(a.timeCreated),
        );
    });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostService {
  // 🔒 Private constructor
  PostService._internal();

  // 🧠 Single instance
  static final PostService _instance = PostService._internal();

  // 🚪 Factory constructor
  factory PostService() => _instance;

  // 🔥 Firebase reference (created once)
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child("posts");

  /// ADD POST
  Future<void> addPost({required String title, required String content}) async {
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
      likes: {},
      comments: <String, dynamic>{},
      createdUser: CreatedUser(
        id: user.uid,
        name: user.displayName ?? "UserName",
      ),
    );

    await _db.child(postId).set(post.toMap());
  }

  /// UPDATE POST
  Future<void> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    await _db.child(postId).update({"title": title, "content": content});
  }

  /// DELETE POST
  Future<void> deletePost(String postId) async {
    await _db.child(postId).remove();
  }

  /// GET POSTS STREAM (REALTIME)
  Stream<List<PostModel>> getPosts() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.values
          .map((post) => PostModel.fromMap(post as Map<dynamic, dynamic>))
          .toList()
        ..sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    });
  }

  /// GET CURRENT USER POSTS
  Stream<List<PostModel>> getCurrentUserPosts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _db.orderByChild("user_id").equalTo(user.uid).onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.values
          .map((post) => PostModel.fromMap(post as Map<dynamic, dynamic>))
          .toList()
        ..sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    });
  }

  Future<int> getCurrentUserPostCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final snapshot = await _db.orderByChild("user_id").equalTo(user.uid).get();

    final data = snapshot.value as Map?;
    return data?.length ?? 0;
  }

  Future<List<PostModel>> fetchPosts({
    int limit = 10,
    int? lastTimeCreated,
  }) async {
    Query query = _db.orderByChild("time_created");

    if (lastTimeCreated != null) {
      query = query.endAt(lastTimeCreated - 1);
    }

    final snapshot = await query.limitToLast(limit).get();
    if (!snapshot.exists) return [];

    final data = snapshot.value as Map;
    final posts = data.values.map((e) => PostModel.fromMap(e as Map)).toList();

    posts.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    return posts;
  }

  Stream<PostModel> listenForNewPosts(int latestTimeCreated) {
    return _db
        .orderByChild("time_created")
        .startAfter(latestTimeCreated)
        .onChildAdded
        .map(
          (event) =>
              PostModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>),
        );
  }

  Stream<String> listenForDeletedPosts() {
    return _db.onChildRemoved.map((event) => event.snapshot.key!);
  }

  Stream<PostModel> listenForUpdatedPosts() {
    return _db.onChildChanged.map(
      (event) =>
          PostModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>),
    );
  }

  ///Adding likes functionality
  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool isLiked,
  }) async {
    final ref = _db.child(postId).child("likes");

    if (isLiked) {
      await ref.child(userId).remove();
    } else {
      await ref.child(userId).set(true);
    }
  }

  ///Adding Comments
  Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    final commentId = FirebaseDatabase.instance
        .ref("posts/$postId/comments")
        .push()
        .key!;

    await FirebaseDatabase.instance
        .ref("posts/$postId/comments/$commentId")
        .set({
          "id": commentId,
          "user_id": userId,
          "user_name": userName,
          "text": comment,
          "created_at": DateTime.now().millisecondsSinceEpoch,
        });
  }

  //Reading Comments
  Stream<List<CommentModel>> getComments(String postId) {
    return FirebaseDatabase.instance.ref("posts/$postId/comments").onValue.map((
      event,
    ) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.values
          .map((e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

}

final postService = PostService();

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/post_model.dart';

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
      comments: [],
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
}

final postService = PostService();

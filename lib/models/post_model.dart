class PostModel {
  final String id;
  final String userId;
  final int timeCreated;
  final String postType;
  final String title;
  final String content;
  final String? image;
  final String? video;
  final Map<String, bool> likes;
  final Map<String, dynamic> comments;
  final CreatedUser createdUser;

  PostModel({
    required this.id,
    required this.userId,
    required this.timeCreated,
    required this.postType,
    required this.title,
    required this.content,
    this.image,
    this.video,
    required this.likes,
    required this.comments,
    required this.createdUser,
  });

  /// Convert Post → Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "time_created": timeCreated,
      "post_type": postType,
      "title": title,
      "content": content,
      "image": image ?? "",
      "video": video ?? "",
      "likes": likes,
      "comments": comments,
      "createdUser": createdUser.toMap(),
    };
  }

  /// Convert Firebase Map → Post
  factory PostModel.fromMap(Map<dynamic, dynamic> map) {
    return PostModel(
      id: map["id"],
      userId: map["user_id"],
      timeCreated: map["time_created"],
      postType: map["post_type"],
      title: map["title"],
      content: map["content"],
      image: map["image"],
      video: map["video"],
      likes: Map<String, bool>.from(map['likes'] ?? {}),
      comments: Map<String, dynamic>.from(map["comments"] ?? {}),
      createdUser: CreatedUser.fromMap(map["createdUser"]),
    );
  }
}

class CreatedUser {
  final String id;
  final String name;

  CreatedUser({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }

  factory CreatedUser.fromMap(Map<dynamic, dynamic> map) {
    return CreatedUser(id: map["id"], name: map["name"]);
  }
}

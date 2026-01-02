class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final int createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "user_name": userName,
        "text": text,
        "created_at": createdAt,
      };

  factory CommentModel.fromMap(Map<dynamic, dynamic> map) {
    return CommentModel(
      id: map["id"],
      userId: map["user_id"],
      userName: map["user_name"],
      text: map["text"],
      createdAt: map["created_at"],
    );
  }
}

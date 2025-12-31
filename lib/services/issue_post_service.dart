import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:generic_company_application/models/issue_post_model.dart';
import 'package:generic_company_application/models/user_model.dart';
import 'package:generic_company_application/utils/issue_constants.dart';
import 'package:generic_company_application/utils/issue_helpers.dart';

class IssuePostService {
  IssuePostService._();
  static final IssuePostService instance = IssuePostService._();

  final _db = FirebaseDatabase.instance.ref("issues");

  Future<void> addIssue({
    required String category,
    required String description,
    required AppUser manager,
    required AppUser admin,
    required AppUser createdBy,
  }) async {
    final id = _db.push().key!;
    final now = DateTime.now().millisecondsSinceEpoch;

    final issue = IssuePost(
      id: id,
      userId: createdBy.id,
      timeCreatedAt: now,
      issueCategory: category,
      issueDescription: description,
      manager: {"id": manager.id, "name": manager.name, "role": "Manager"},
      admin: {"id": admin.id, "name": admin.name, "role": "Admin"},
      status: IssueStatus.pending,
      updatedTimeAt: now,
      tags: ["pending"],
      createdBy: {
        "id": createdBy.id,
        "name": createdBy.name,
        "role": createdBy.role,
      },
      priority: getPriorityFromCategory(category),
    );

    await _db.child(id).set(issue.toMap());
  }

  Stream<List<IssuePost>> fetchAllIssues() {
    return _db.onValue.map(_mapIssues);
  }

  Stream<List<IssuePost>> fetchIssuesByUser(String userId) {
    return _db.orderByChild("user_id").equalTo(userId).onValue.map(_mapIssues);
  }

  // Stream<int> getIssueCountForCurrentUser() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return Stream.value(0);

  //   return _db.orderByChild("user_id").equalTo(user.uid).onValue.map((event) {
  //     final data = event.snapshot.value as Map?;
  //     if (data == null) return 0;
  //     return data.length;
  //   });
  // }
  Future<int> getIssueCountForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final snapshot = await _db.orderByChild("user_id").equalTo(user.uid).get();

    final data = snapshot.value as Map?;
    return data?.length ?? 0;
  }

  Stream<List<IssuePost>> fetchIssuesForLoggedInUser(AppUser user) {
    switch (user.role) {
      case "Admin":
      case "Manager":
        return fetchAllIssues();
      default:
        return fetchIssuesByUser(user.id);
    }
  }

  List<IssuePost> _mapIssues(DatabaseEvent event) {
    final data = event.snapshot.value as Map?;
    if (data == null) return [];

    return data.values
        .map((e) => IssuePost.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> deleteIssue(String issueId) async {
    await _db.child(issueId).remove();
  }

  Future<void> updateIssueStatus(
    String issueId,
    IssueStatus status,
    List<String> tags,
  ) async {
    await _db.child(issueId).update({
      "status": status.value,
      "updated_time_at": DateTime.now().millisecondsSinceEpoch,
      "tags": tags,
    });
  }
}

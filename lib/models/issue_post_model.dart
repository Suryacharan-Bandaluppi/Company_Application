import 'package:generic_company_application/screens/concerns/issue_constants.dart';

class IssuePost {
  final String id;
  final String userId;
  final int timeCreatedAt;
  final String issueCategory;
  final String issueDescription;

  final Map<String, dynamic> manager;
  final Map<String, dynamic> admin;

  final IssueStatus status;
  final int updatedTimeAt;
  final List<String> tags;

  final Map<String, dynamic> createdBy;
  final int priority;

  IssuePost({
    required this.id,
    required this.userId,
    required this.timeCreatedAt,
    required this.issueCategory,
    required this.issueDescription,
    required this.manager,
    required this.admin,
    required this.status,
    required this.updatedTimeAt,
    required this.tags,
    required this.createdBy,
    required this.priority,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'time_created_at': timeCreatedAt,
    'issue_category': issueCategory,
    'issue_description': issueDescription,
    'manager': manager,
    'admin': admin,
    'status': status.value,
    'updated_time_at': updatedTimeAt,
    'tags': tags,
    'created_by': createdBy,
    'priority': priority,
  };

  factory IssuePost.fromMap(Map data) => IssuePost(
    id: data['id'],
    userId: data['user_id'],
    timeCreatedAt: data['time_created_at'],
    issueCategory: data['issue_category'],
    issueDescription: data['issue_description'],
    manager: Map<String, dynamic>.from(data['manager']),
    admin: Map<String, dynamic>.from(data['admin']),
    status: IssueStatus.values.firstWhere(
      (e) => e.name == data['status'],
      orElse: () => IssueStatus.pending,
    ),
    updatedTimeAt: data['updated_time_at'],
    tags: List<String>.from(data['tags'] ?? []),
    createdBy: Map<String, dynamic>.from(data['created_by']),
    priority: data['priority'],
  );
}

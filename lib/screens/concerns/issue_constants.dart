enum IssueStatus {
  pending,
  approved,
  declined,
}

extension IssueStatusX on IssueStatus {
  String get value => name;
}

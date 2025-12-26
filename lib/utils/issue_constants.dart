enum IssueStatus {
  pending,
  managerApproved,
  managerRejected,
  adminApproved,
  adminRejected,
}

extension IssueStatusX on IssueStatus {
  String get value => name;
}

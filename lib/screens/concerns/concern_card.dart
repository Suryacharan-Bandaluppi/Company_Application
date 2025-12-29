import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/issue_post_model.dart';
import 'package:generic_company_application/models/user_model.dart';
import 'package:generic_company_application/screens/widgets/status_badge_widget.dart';
import 'package:generic_company_application/screens/widgets/time_line_widget.dart';
import 'package:generic_company_application/services/issue_post_service.dart';
import 'package:generic_company_application/services/user_service.dart';
import 'package:generic_company_application/utils/helpers.dart';
import 'package:generic_company_application/utils/issue_constants.dart';

class ConcernCard extends StatefulWidget {
  final IssuePost issue;

  const ConcernCard({super.key, required this.issue});

  @override
  State<ConcernCard> createState() => _ConcernCardState();
}

class _ConcernCardState extends State<ConcernCard> {
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await UserService.instance.getUserById(uid);

    if (!mounted) return;

    setState(() {
      currentUser = user;
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    final role = currentUser?.role ?? "NO ROLE";

    if (Helpers.canDeleteIssue(role, widget.issue.status)) {
      return ElevatedButton(
        onPressed: () async {
          final confirm = await Helpers.showDialogBox(
            context,
            "Delete Issue",
            "Are you sure you want to delete this issue?",
            "Cancel",
            "Delete",
          );
          if (confirm == true) {
            await IssuePostService.instance.deleteIssue(widget.issue.id);
          }
        },
        child: const Text("Delete"),
      );
    }

    if (Helpers.canManagerApprove(role, widget.issue.status)) {
      return ElevatedButton(
        onPressed: () async {
          final confirm = await Helpers.showDialogBox(
            context,
            "Approve Issue",
            "Are you sure you want to Approve this issue?",
            "Reject",
            "Approve",
          );

          if (confirm == true) {
            await IssuePostService.instance.updateIssueStatus(
              widget.issue.id,
              IssueStatus.managerApproved,
              [...widget.issue.tags, "managerApproved"],
            );
          } else if (confirm == false) {
            await IssuePostService.instance.updateIssueStatus(
              widget.issue.id,
              IssueStatus.managerRejected,
              [...widget.issue.tags, "managerRejected"],
            );
          }
        },
        child: const Text("Approve"),
      );
    }

    if (Helpers.canAdminApprove(role, widget.issue.status)) {
      return ElevatedButton(
        onPressed: () async {
          final confirm = await Helpers.showDialogBox(
            context,
            "Approve Issue",
            "Are you sure you want to Approve this issue?",
            "Reject",
            "Approve",
          );

          if (confirm == true) {
            await IssuePostService.instance.updateIssueStatus(
              widget.issue.id,
              IssueStatus.adminApproved,
              [...widget.issue.tags, "adminApproved"],
            );
          } else if (confirm == false) {
            await IssuePostService.instance.updateIssueStatus(
              widget.issue.id,
              IssueStatus.adminRejected,
              [...widget.issue.tags, "adminRejected"],
            );
          }
        },
        child: const Text("Approve"),
      );
    }

    if (Helpers.managerApprovalStillPending(role, widget.issue.status)) {
      return Text(
        "Manager Approval Pending",
        style: TextStyle(color: Colors.red),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    bool isManagerApproved = widget.issue.tags.contains("managerApproved");
    bool isAdminApproved = widget.issue.tags.contains("adminApproved");
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.issue.createdBy['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.issue.createdBy['role'],
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                _buildActionButtons(context),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.issue.issueCategory,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text("Priority : ${widget.issue.priority}"),
              ],
            ),

            const SizedBox(height: 8),

            Text(widget.issue.issueDescription, style: TextStyle(fontSize: 14)),

            const SizedBox(height: 14),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadgeWidget(
                  text: widget.issue.status.name,
                  color: _statusBgColor(widget.issue.status),
                  textColor: _statusTextColor(widget.issue.status),
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(
                    widget.issue.timeCreatedAt,
                  ).toString().split(' ')[0],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimeLineWidget(label: "You", isCompleted: true),
                const Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(
                  label: "Manager",
                  isCompleted: isManagerApproved,
                ),
                const Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(label: "Admin", isCompleted: isAdminApproved),
                Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(label: "Resolved", isCompleted: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusBgColor(IssueStatus status) {
  switch (status) {
    case IssueStatus.managerApproved || IssueStatus.adminApproved:
      return Colors.green.shade100;
    case IssueStatus.managerRejected || IssueStatus.adminRejected:
      return Colors.red.shade100;
    default:
      return Colors.orange.shade100;
  }
}

Color _statusTextColor(IssueStatus status) {
  switch (status) {
    case IssueStatus.managerApproved || IssueStatus.adminApproved:
      return Colors.green;
    case IssueStatus.managerRejected || IssueStatus.adminRejected:
      return Colors.red;
    default:
      return Colors.orange;
  }
}

import 'package:flutter/material.dart';
import 'package:generic_company_application/models/issue_post_model.dart';
import 'package:generic_company_application/screens/concerns/issue_constants.dart';

class ConcernCard extends StatelessWidget {
  final IssuePost issue;
  const ConcernCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
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
                        issue.createdBy['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        issue.createdBy['role'],
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(onPressed: () {}, child: Text("Delete")),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  issue.issueCategory,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text("Priority : ${issue.priority}"),
              ],
            ),

            const SizedBox(height: 8),

            Text(issue.issueDescription, style: TextStyle(fontSize: 14)),

            const SizedBox(height: 14),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Badge(
                  text: issue.status.name.toUpperCase(),
                  color: _statusBgColor(issue.status),
                  textColor: _statusTextColor(issue.status),
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(
                    issue.timeCreatedAt,
                  ).toString().split(' ')[0],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimeLineWidget(label: "You", isCompleted: true),
                Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(label: "Manager", isCompleted: true),
                Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(label: "Admin", isCompleted: false),
                Expanded(child: Divider(thickness: 2)),
                TimeLineWidget(label: "Status", isCompleted: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

Color _statusBgColor(IssueStatus status) {
  switch (status) {
    case IssueStatus.approved:
      return Colors.green.shade100;
    case IssueStatus.declined:
      return Colors.red.shade100;
    default:
      return Colors.orange.shade100;
  }
}

Color _statusTextColor(IssueStatus status) {
  switch (status) {
    case IssueStatus.approved:
      return Colors.green;
    case IssueStatus.declined:
      return Colors.red;
    default:
      return Colors.orange;
  }
}

class TimeLineWidget extends StatelessWidget {
  final String label;
  final bool isCompleted;

  const TimeLineWidget({
    super.key,
    required this.label,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isCompleted ? Colors.green : Colors.grey.shade400,
          child: isCompleted
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : const Icon(Icons.circle, size: 6, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:generic_company_application/utils/issue_constants.dart';
import 'package:go_router/go_router.dart';

class Helpers {
  /// show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  ///show Dialog box for the concern card buttons
  static Future<bool?> showDialogBox(
    BuildContext context,
    String titleText,
    String contentText,
    String btn1Text,
    String btn2Text,
  ) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleText),
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.cancel),
            ),
          ],
        ),
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(btn1Text),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            child: Text(btn2Text),
          ),
        ],
      ),
    );
  }

  static bool canDeleteIssue(String role, IssueStatus status) {
    return role == "Employee" && status == IssueStatus.pending;
  }

  static bool canManagerApprove(String role, IssueStatus status) {
    return role == "Manager" && status == IssueStatus.pending;
  }

  static bool canAdminApprove(String role, IssueStatus status) {
    return role == "Admin" && status == IssueStatus.managerApproved;
  }

  static bool managerApprovalStillPending(String role, IssueStatus status) {
    return role == "Admin" && status == IssueStatus.pending;
  }

  static bool canManagerDelete(String role, IssueStatus status) {
    return role == "Manager" && status == IssueStatus.adminApproved;
  }

  static bool isAdminApproved(String role, IssueStatus status) {
    return status == IssueStatus.adminApproved &&
        (role == "Admin" || role == "Employee");
  }
}

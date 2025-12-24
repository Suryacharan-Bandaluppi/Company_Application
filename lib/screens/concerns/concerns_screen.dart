import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/issue_post_model.dart';
import 'package:generic_company_application/models/user_model.dart';
import 'package:generic_company_application/screens/concerns/concern_card.dart';
import 'package:generic_company_application/services/issue_post_service.dart';
import 'package:generic_company_application/services/user_service.dart';

class ConcernsScreen extends StatefulWidget {
  const ConcernsScreen({super.key});

  @override
  State<ConcernsScreen> createState() => _ConcernsScreenState();
}

class _ConcernsScreenState extends State<ConcernsScreen> {
  AppUser? currentUser;
  bool isLoadingUser = true;

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
      isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Concerns")),
      body: isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<IssuePost>>(
              stream: IssuePostService.instance.fetchIssuesForLoggedInUser(
                currentUser!,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final issues = snapshot.data!;

                if (issues.isEmpty) {
                  return const Center(child: Text("No concerns found"));
                }

                return ListView.builder(
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    return ConcernCard(issue: issues[index]);
                  },
                );
              },
            ),
    );
  }
}

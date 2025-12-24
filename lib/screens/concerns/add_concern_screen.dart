import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/screens/widgets/drop_down_widget.dart';
import 'package:generic_company_application/services/issue_post_service.dart';
import 'package:generic_company_application/services/user_service.dart';
import 'package:generic_company_application/utils/helpers.dart';

class AddConcernScreen extends StatefulWidget {
  const AddConcernScreen({super.key});

  @override
  State<AddConcernScreen> createState() => _AddConcernScreenState();
}

class _AddConcernScreenState extends State<AddConcernScreen> {
  String selectedCategory = "Technical Issues";
  bool isSubmitting = false;

  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submitConcern() async {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the issue")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      /// 1️⃣ Get current logged-in user ID
      // print("AUTH UID: ${FirebaseAuth.instance.currentUser?.uid}");
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // print("STEP 1: currentUserId fetched");

      /// 2️⃣ Fetch current user details
      final createdBy = await UserService.instance.getUserById(currentUserId);
      // print("STEP 2: createdBy fetched");

      if (createdBy == null) {
        throw Exception("User not found");
      }

      /// 3️⃣ Fetch managers
      final managers = await UserService.instance.getManagers();
      // print("STEP 3: managers fetched: ${managers.length}");
      if (managers.isEmpty) {
        throw Exception("No manager available");
      }

      /// 4️⃣ Fetch admins
      final admins = await UserService.instance.getAdmins();
      // print("STEP 4: admins fetched: ${admins.length}");

      if (admins.isEmpty) {
        throw Exception("No admin available");
      }

      final manager = managers.first;
      final admin = admins.first;
      // print("STEP 5: calling addIssue()");

      /// 5️⃣ Create Issue
      await IssuePostService.instance.addIssue(
        category: selectedCategory,
        description: descriptionController.text.trim(),
        manager: manager,
        admin: admin,
        createdBy: createdBy,
      );
      descriptionController.clear();

      /// 6️⃣ Success
      Helpers.showSuccessSnackbar(context, "Concern submitted successfully ✅");
    } catch (e) {
      Helpers.showErrorSnackbar(context, "Failed to submit concern: $e");
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Concern"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: const Text(
                    "User Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Public"),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Issue Category",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropDownWidget(
                    onChanged: (value) {
                      selectedCategory = value;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Issue Description",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: "Describe your issue clearly...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Attachments",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.image, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.video_collection,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitConcern,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Concern",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

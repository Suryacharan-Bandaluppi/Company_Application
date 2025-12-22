import 'package:flutter/material.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isOpen) ...[
          FloatingActionButton.extended(
            heroTag: "addPost",
            label: Text("Add Posts"),
            tooltip: "Add Post",
            extendedPadding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 10.0,
              bottom: 10.0,
            ),
            onPressed: () {
              setState(() => isOpen = false);
              context.push(AppRoutes.addPost);
            },
            icon: const Icon(Icons.post_add),
          ),

          const SizedBox(height: 10),

          FloatingActionButton.extended(
            heroTag: "addConcern",
            tooltip: "Add Concern",
            label: Text("Add Concerns"),
            onPressed: () {
              setState(() => isOpen = false);
              context.push(AppRoutes.addConcern);
            },
            icon: const Icon(Icons.report_problem_outlined),
          ),
          const SizedBox(height: 10),
        ],
        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: () {
            setState(() => isOpen = !isOpen);
          },
          child: Icon(isOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}

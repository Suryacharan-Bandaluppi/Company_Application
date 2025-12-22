import 'package:flutter/material.dart';

class ConcernCard extends StatelessWidget {
  const ConcernCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Syed Noman",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "12/19/2025",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              "Manager/TeamLead Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),
            const Divider(height: 20),

            Text(
              "Issue: Issues in the Desktop need to be resolved",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // YOU
                TimeLineWidget(position: "You"),

                const Expanded(child: Divider(thickness: 2)),

                // MANAGER
                TimeLineWidget(position: "Manager"),

                const Expanded(child: Divider(thickness: 2)),

                // ADMIN
                TimeLineWidget(position: "Admin"),

                const Expanded(child: Divider(thickness: 2)),

                // STATUS
                TimeLineWidget(position: "Status"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  final String position;
  const TimeLineWidget({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.green,
            child: Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(position, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

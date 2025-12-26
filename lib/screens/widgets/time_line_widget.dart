import 'package:flutter/material.dart';

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

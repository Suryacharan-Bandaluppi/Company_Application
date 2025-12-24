import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DropDownWidget({super.key, required this.onChanged}); 

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String dropDownValue = "Technical Issues";

  final List<String> issues = [
    "Technical Issues",
    "Hardware Issues",
    "Software Glitches",
    "Connection Issues",
    "Authentication Issues",
    "Security Concern",
    "Malware Concern",
    "Equipment Requests",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: dropDownValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: const InputDecoration(border: InputBorder.none),
      items: issues
          .map((issue) => DropdownMenuItem(value: issue, child: Text(issue)))
          .toList(),
      onChanged: (value) {
        setState(() {
          dropDownValue = value!;
        });
        widget.onChanged(value!);
      },
    );
  }
}

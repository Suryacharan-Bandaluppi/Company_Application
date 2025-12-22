import 'package:flutter/material.dart';
import 'package:generic_company_application/screens/concerns/concern_card.dart';

class ConcernsScreen extends StatefulWidget {
  const ConcernsScreen({super.key});

  @override
  State<ConcernsScreen> createState() => _ConcernsScreenState();
}

class _ConcernsScreenState extends State<ConcernsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Concerns")),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ConcernCard();
        },
      ),
    );
  }
}

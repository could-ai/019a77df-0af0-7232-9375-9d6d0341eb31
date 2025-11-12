import 'package:flutter/material.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário'),
      ),
      body: const Center(
        child: Text('Journal Screen Placeholder'),
      ),
    );
  }
}

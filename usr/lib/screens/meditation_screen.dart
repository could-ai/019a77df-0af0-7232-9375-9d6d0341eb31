import 'package:flutter/material.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditação'),
      ),
      body: const Center(
        child: Text('Meditation Screen Placeholder'),
      ),
    );
  }
}

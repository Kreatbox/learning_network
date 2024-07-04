import 'package:flutter/material.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدروس'),
      ),
      body: const Center(
        child: Text('هذه هية صفحة الدروس'),
      ),
    );
  }
}

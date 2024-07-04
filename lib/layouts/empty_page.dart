import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة فارغة للتعديل عند الحاجة'),
      ),
      body: const Center(
        child: Text('هون اذا في صفحة لنباشر شغل فيها'),
      ),
    );
  }
}

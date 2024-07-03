import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة فارغة للتعديل عند الحاجة'),
      ),
      body: Center(
        child: Text('هون اذا في صفحة لنباشر شغل فيها'),
      ),
    );
  }
}

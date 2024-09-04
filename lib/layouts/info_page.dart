// info_page.dart
import 'package:flutter/material.dart';
import 'package:learning_network/nav_bar.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text(
            "الأسماء والأرقام الجامعية للطلاب المشاركين في المشروع "),
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 2), // Use the new widget
      body: Stack(
        children: [
          Container(
            height: 1000,
            color: Colors.blue,
          ),
          const Center(
            child: Text(
              'هون اذا في صفحة لنباشر شغل فيها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

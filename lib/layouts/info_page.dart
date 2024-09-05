// info_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        centerTitle: true,
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 2), // Use the new widget
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            )),
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

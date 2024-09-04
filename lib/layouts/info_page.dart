import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "الأسماء والأرقام الجامعية للطلاب المشاركين في المشروع "),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_motion_rounded),
            label: "الدروس",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_sharp),
            label: "التدريبات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "الطلاب المشاركة",
          ),
        ],
        onTap: (value) {
          if (value == 1) Navigator.pushNamed(context, "lessons");
          if (value == 2) Navigator.pushNamed(context, "tests");
          if (value == 0) Navigator.pushNamed(context, "info");
        },
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
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

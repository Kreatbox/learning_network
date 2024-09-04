// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  // المُنشئ الذي يتطلب تمرير الفهرس الحالي كمعامل
  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue[200], // لون الخلفية لشريط التنقل السفلي
      currentIndex:
          currentIndex, // الفهرس الحالي الذي يعكس الصفحة النشطة حاليًا
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_motion_rounded,
              color: Colors.indigo), // أيقونة العنصر الأول
          backgroundColor: Colors.blue, // لون الخلفية عند تحديد العنصر
          label: "الدروس", // التسمية النصية للعنصر الأول
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_tree_sharp,
              color: Colors.indigo), // أيقونة العنصر الثاني
          label: "التدريبات", // التسمية النصية للعنصر الثاني
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded,
              color: Colors.indigo), // أيقونة العنصر الثالث
          label: "الطلاب المشاركة", // التسمية النصية للعنصر الثالث
        ),
      ],
      onTap: (value) {
        // التحقق مما إذا كان العنصر الذي تم النقر عليه هو نفسه العنصر الحالي
        if (value == currentIndex) {
          return; // عدم تنفيذ أي شيء إذا كان العنصر الذي تم النقر عليه هو نفسه المختار حاليًا
        }

        // التنقل فقط إذا كان العنصر الذي تم النقر عليه مختلفًا عن الحالي
        if (value == 0)
          Navigator.pushNamed(context,
              '/lessons'); // الانتقال إلى صفحة الدروس إذا تم اختيار العنصر الأول
        if (value == 1)
          Navigator.pushNamed(context,
              '/tests'); // الانتقال إلى صفحة التدريبات إذا تم اختيار العنصر الثاني
        if (value == 2)
          Navigator.pushNamed(context,
              '/info'); // الانتقال إلى صفحة المعلومات إذا تم اختيار العنصر الثالث
      },
    );
  }
}

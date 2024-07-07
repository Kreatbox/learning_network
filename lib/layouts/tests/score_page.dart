import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ScorePage(
      {super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النتائج'),
      ),
      body: Stack(
        children: [
          // إعداد الخلفية للصورة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // إعداد واجهة النتيجة في منتصف الشاشة
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'علامتك',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  '$score / $totalQuestions',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // العودة إلى صفحة الاختبارات الرئيسية
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('العودة إلى الاختبارات'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

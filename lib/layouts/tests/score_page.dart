import 'package:flutter/material.dart';
import 'package:learning_network/database/database_helper.dart';
import 'package:learning_network/models/tests/test_model.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int testId;

  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.testId,
  });

  void updateTestScore(int testId, int score, int totalQuestions) async {
    final dbHelper = DatabaseHelper();

    // Fetch the current test details
    Test? currentTest = await dbHelper.getTestById(testId);

    if (currentTest != null) {
      // Calculate the new score percentage
      double newPercentage = (score / totalQuestions) * 100;

      // Calculate the updated average percentage
      double updatedPercentage =
          ((currentTest.scorePercentage * currentTest.attempts) +
                  newPercentage) /
              (currentTest.attempts + 1);

      // Update the attempts
      int newAttempts = currentTest.attempts + 1;

      // Update the test record in the database
      await dbHelper.updateTestScore(testId, updatedPercentage, newAttempts);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call updateTestScore when the score page is shown
    updateTestScore(testId, score, totalQuestions);

    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('النتائج'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // إعداد واجهة النتيجة في منتصف الشاشة
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: const Text(
                    'علامتك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  width: double.infinity,
                  child: Text(
                    '$score / $totalQuestions',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                  ),
                  width: double.infinity,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // العودة إلى صفحة الاختبارات الرئيسية
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.blue,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'العودة إلى الصفحة الرئيسية',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

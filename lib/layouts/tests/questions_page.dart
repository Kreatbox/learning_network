// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/tests/question_model.dart';
import 'score_page.dart';

class QuestionsPage extends StatefulWidget {
  final int testId;

  const QuestionsPage({Key? key, required this.testId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Future<List<Question>> futureQuestions;
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false; // لتتبع ما إذا تم اختيار إجابة
  int selectedChoice = -1; // لتتبع الخيار المختار، -1 يعني لم يتم اختيار خيار

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
  }

  // دالة لجلب الأسئلة من قاعدة البيانات
  Future<List<Question>> fetchQuestions() async {
    List<Map<String, dynamic>> questionsMapList =
        await dbHelper.getQuestions(widget.testId);
    return questionsMapList.map((map) => Question.fromJson(map)).toList();
  }

  // دالة لإرسال الإجابة وتحديث النقاط وحالة السؤال
  void submitAnswer(int choiceIndex) async {
    setState(() {
      selectedChoice = choiceIndex;
      answered = true; // إشارة بأنه تم اختيار إجابة
      if (questions[currentQuestionIndex].correctChoice == selectedChoice + 1) {
        score++; // زيادة النقاط إذا كانت الإجابة صحيحة
        dbHelper.updateQuestionState(questions[currentQuestionIndex].questionId,
            1); // تحديث الحالة إلى 1 للإجابة الصحيحة
      } else {
        dbHelper.updateQuestionState(questions[currentQuestionIndex].questionId,
            -1); // تحديث الحالة إلى -1 للإجابة الخاطئة
      }
    });
  }

  // دالة للانتقال إلى السؤال التالي
  void nextQuestion() {
    setState(() {
      answered = false; // إعادة تعيين حالة الإجابة
      selectedChoice = -1; // إعادة تعيين الاختيار المحدد
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScorePage(
              score: score,
              totalQuestions: questions.length,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Stack(
        children: [
          Container(
            height: 220,
            color: Colors.blue[400],
          ),
          // مركز الصفحة
          Center(
            child: FutureBuilder<List<Question>>(
              future: futureQuestions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('لا يوجد أسئلة.');
                } else {
                  questions = snapshot.data!;
                  Question currentQuestion = questions[currentQuestionIndex];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // نص السؤال
                      Container(
                        height: 100,
                        color: Colors.blue,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            currentQuestion.questionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // الخيارات
                      Column(
                        children: [
                          for (int i = 0; i < 4; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: answered
                                      ? null
                                      : () {
                                          submitAnswer(i);
                                        },
                                  style: ButtonStyle(
                                    backgroundColor: answered &&
                                            (selectedChoice == i ||
                                                currentQuestion.correctChoice ==
                                                    i + 1)
                                        ? (currentQuestion.correctChoice ==
                                                i + 1
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.green)
                                            : MaterialStateProperty.all<Color>(
                                                Colors.red))
                                        : null,
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      currentQuestion.choices[i],
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // زر التالي
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: answered
                              ? () {
                                  nextQuestion();
                                }
                              : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                          child: Text(
                            answered &&
                                    currentQuestionIndex == questions.length - 1
                                ? 'انتهى'
                                : 'التالي',
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

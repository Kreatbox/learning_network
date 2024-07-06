import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  // دالة لجلب الاختبارات من قاعدة البيانات
  Future<List<Test>> fetchTests() async {
    // إنشاء كائن DatabaseHelper للوصول إلى قاعدة البيانات
    final dbHelper = DatabaseHelper();

    // جلب قائمة من خرائط البيانات (Map) التي تمثل الاختبارات من قاعدة البيانات
    final testsMapList = await dbHelper.getTests();

    // تحويل قائمة الخرائط إلى قائمة من كائنات Test باستخدام fromJson
    return testsMapList.map((map) => Test.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإختبارات'),
      ),
      body: Stack(
        children: [
          // خلفية الصفحة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // بناء واجهة المستخدم بناءً على البيانات المسترجعة من قاعدة البيانات
          FutureBuilder<List<Test>>(
            future: fetchTests(), // استدعاء دالة جلب البيانات من قاعدة البيانات
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // الحصول على البيانات من snapshot إذا كانت موجودة
                List<Test>? tests = snapshot.data;

                // عرض قائمة بالاختبارات باستخدام ListView.builder
                return ListView.builder(
                  itemCount: tests!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 2.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              tests[index].testName,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuestionsPage(testId: tests[index].testId),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات الاختبار
class Test {
  final int testId;
  final int lessonId;
  final String testName;

  Test({required this.testId, required this.lessonId, required this.testName});

  // إنشاء كائن Test من JSON
  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testId: json['test_id'],
      lessonId: json['lesson_id'],
      testName: json['test_name'],
    );
  }
}

// صفحة عرض الأسئلة
class QuestionsPage extends StatefulWidget {
  final int testId;

  const QuestionsPage({super.key, required this.testId});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  // متغير للاحتفاظ بالأسئلة المستقبلة من قاعدة البيانات
  late Future<List<Question>> futureQuestions;
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  List<int> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    // استدعاء دالة جلب الأسئلة من قاعدة البيانات عند تهيئة الصفحة
    futureQuestions = fetchQuestions();
  }

  // دالة لجلب الأسئلة من قاعدة البيانات
  Future<List<Question>> fetchQuestions() async {
    // إنشاء كائن DatabaseHelper للوصول إلى قاعدة البيانات
    final dbHelper = DatabaseHelper();

    // جلب قائمة من خرائط البيانات (Map) التي تمثل الأسئلة من قاعدة البيانات
    final questionsMapList = await dbHelper.getQuestions(widget.testId);

    // تحويل قائمة الخرائط إلى قائمة من كائنات Question باستخدام fromJson
    return questionsMapList.map((map) => Question.fromJson(map)).toList();
  }

  // دالة لإرسال الإجابة والتحقق منها
  void submitAnswer(int selectedChoice) {
    setState(() {
      selectedChoices.add(selectedChoice);
      // التحقق من صحة الإجابة المرسلة
      if (questions[currentQuestionIndex].correctChoice == selectedChoice) {
        score++;
      }
      // الانتقال إلى السؤال التالي أو عرض صفحة النتيجة
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ScorePage(score: score, totalQuestions: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة'),
      ),
      body: Stack(
        children: [
          // خلفية الصفحة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // بناء واجهة المستخدم بناءً على البيانات المسترجعة من قاعدة البيانات
          FutureBuilder<List<Question>>(
            future:
                futureQuestions, // استدعاء دالة جلب البيانات من قاعدة البيانات
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                questions = snapshot.data!;
                Question currentQuestion = questions[currentQuestionIndex];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentQuestion.questionText,
                          style: const TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // عرض الخيارات للإجابة على السؤال
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () => submitAnswer(
                                  index + 1), // إرسال الإجابة عند النقر
                              title: Text(
                                currentQuestion.choices[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات السؤال
class Question {
  final int questionId;
  final String questionText;
  final List<String> choices;
  final int correctChoice;
  final int state;

  Question({
    required this.questionId,
    required this.questionText,
    required this.choices,
    required this.correctChoice,
    required this.state,
  });

  // إنشاء كائن Question من JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      questionText: json['question_text'],
      choices: [
        json['choice1'],
        json['choice2'],
        json['choice3'],
        json['choice4']
      ],
      correctChoice: json['correct_choice'],
      state: json['state'],
    );
  }
}

// صفحة عرض النتيجة النهائية
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
          // خلفية الصفحة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // عرض النتيجة النهائية
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

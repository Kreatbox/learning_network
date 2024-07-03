import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class TestsPage extends StatelessWidget {
  Future<List<Test>> fetchTests() async {
    final dbHelper = DatabaseHelper();
    final testsMapList = await dbHelper.getTests();
    return testsMapList.map((map) => Test.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التدريبات'),
      ),
      body: FutureBuilder<List<Test>>(
        future: fetchTests(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Test>? tests = snapshot.data;
            return ListView.builder(
              itemCount: tests!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tests[index].testName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuestionsPage(testId: tests[index].testId)),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Test {
  final int testId;
  final int lessonId;
  final String testName;

  Test({required this.testId, required this.lessonId, required this.testName});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testId: json['test_id'],
      lessonId: json['lesson_id'],
      testName: json['test_name'],
    );
  }
}

class QuestionsPage extends StatelessWidget {
  final int testId;

  QuestionsPage({required this.testId});

  Future<List<Question>> fetchQuestions() async {
    final dbHelper = DatabaseHelper();
    final questionsMapList = await dbHelper.getQuestions(testId);
    return questionsMapList.map((map) => Question.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأسئلة'),
      ),
      body: FutureBuilder<List<Question>>(
        future: fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Question>? questions = snapshot.data;
            return ListView.builder(
              itemCount: questions!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index].questionText),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < 4; i++)
                        Text(questions[index].choices[i]),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Question {
  final int questionId;
  final String questionText;
  final List<String> choices;
  final int correctChoice;
  final int state;

  Question(
      {required this.questionId,
      required this.questionText,
      required this.choices,
      required this.correctChoice,
      required this.state});

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

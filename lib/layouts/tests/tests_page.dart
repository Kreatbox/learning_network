import 'package:flutter/material.dart';
import 'package:learning_network/nav_bar.dart';
import '../../database/database_helper.dart';
import '../../models/tests/test_model.dart';
import 'questions_page.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  // دالة لجلب الاختبارات من قاعدة البيانات
  Future<List<Test>> fetchTests() async {
    final dbHelper = DatabaseHelper();
    // جلب قائمة الاختبارات من قاعدة البيانات على شكل خرائط
    final testsMapList = await dbHelper.getTests();
    // تحويل البيانات من شكل خريطة إلى كائنات Test
    return testsMapList.map((map) => Test.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('الإختبارات'),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          Container(
            height: 1000,
            color: Colors.blue,
          ),
          // FutureBuilder لبناء الواجهة بناءً على بيانات قاعدة البيانات
          FutureBuilder<List<Test>>(
            future: fetchTests(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Test>? tests = snapshot.data;
                // عرض قائمة الاختبارات باستخدام ListView.builder
                return ListView.builder(
                  itemCount: tests!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Card(
                        elevation: 0,
                        color: Colors.blue[200],
                        shape: const RoundedRectangleBorder(),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              tests[index].testName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // عند الضغط على أي اختبار، يتم الانتقال إلى صفحة الأسئلة الخاصة بهذا الاختبار
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
                // عرض رسالة خطأ في حال حدوث مشكلة في جلب البيانات
                return Center(child: Text("${snapshot.error}"));
              }
              // عرض مؤشر تحميل في حال لم تنتهي عملية جلب البيانات بعد
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

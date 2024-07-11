import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../models/lessons/lesson_model.dart';
import 'lesson_details_page.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  // دالة لجلب الدروس من قاعدة البيانات
  Future<List<Lesson>> fetchLessons() async {
    final dbHelper = DatabaseHelper();
    // جلب قائمة الدروس من قاعدة البيانات على شكل خرائط
    final lessonsMapList = await dbHelper.getLessons();
    // تحويل البيانات من شكل خريطة إلى كائنات Lesson
    return lessonsMapList.map((map) => Lesson.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدروس'),
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
          // FutureBuilder لبناء الواجهة بناءً على بيانات قاعدة البيانات
          FutureBuilder<List<Lesson>>(
            future: fetchLessons(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Lesson>? lessons = snapshot.data;
                // عرض قائمة الدروس باستخدام ListView.builder
                return ListView.builder(
                  itemCount: lessons!.length,
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
                              lessons[index].lessonName,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // عند الضغط على أي درس، يتم الانتقال إلى صفحة التفاصيل الخاصة بهذا الدرس
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonDetailsPage(
                                    lessonId: lessons[index].lessonId),
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

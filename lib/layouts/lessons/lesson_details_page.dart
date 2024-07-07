import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/lessons/lesson_model.dart';

class LessonDetailsPage extends StatelessWidget {
  final int lessonId;

  const LessonDetailsPage({required this.lessonId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الدرس'),
      ),
      body: FutureBuilder<Lesson>(
        future: fetchLesson(), // استدعاء دالة fetchLesson() لجلب بيانات الدرس
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // في حالة انتظار تحميل البيانات، عرض مؤشر التحميل
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // في حالة حدوث خطأ أثناء جلب البيانات، عرض رسالة الخطأ
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // إذا لم تكن هناك بيانات متوفرة للدرس، عرض رسالة بدون بيانات
            return const Center(child: Text('لا يوجد بيانات للدرس'));
          } else {
            // إذا تم جلب البيانات بنجاح، عرض تفاصيل الدرس
            Lesson lesson = snapshot.data!; // استخدام البيانات المسترجعة
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    ':رقم الدرس', // عنوان الرقم التعريفي للدرس
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lesson.lesson_id.toString(), // عرض الرقم التعريفي للدرس
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    ':اسم الدرس', // عنوان اسم الدرس
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lesson.lesson_name, // عرض اسم الدرس
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // دالة لجلب بيانات الدرس من قاعدة البيانات باستخدام معرف الدرس
  Future<Lesson> fetchLesson() async {
    final dbHelper = DatabaseHelper();
    Map<String, dynamic>? lessonMap = await dbHelper.getLessonById(lessonId);
    return Lesson.fromJson(
        lessonMap!); // تحويل البيانات المسترجعة إلى كائن من نوع Lesson
  }
}

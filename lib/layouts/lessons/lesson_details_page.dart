import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../database/database_helper.dart'; // استيراد مكتبة قاعدة البيانات
import '../../models/lessons/lesson_model.dart'; // استيراد نموذج الدرس
import 'lesson_details_helpers.dart'; // استيراد ملف المساعد للدرس

class LessonDetailsPage extends StatefulWidget {
  final int lessonId; // معرّف الدرس
  const LessonDetailsPage({required this.lessonId, Key? key}) : super(key: key);

  @override
  // تجاهل التحذير حول أنواع المكتبة الخاصة في الواجهة العامة
  LessonDetailsPageState createState() => LessonDetailsPageState();
}

class LessonDetailsPageState extends State<LessonDetailsPage> {
  late Future<Lesson> _lessonFuture; // مستقبلاً يحمل بيانات الدرس
  YoutubePlayerController? _youtubePlayerController; // متحكم لمشغل الفيديو
  var _currentStep = 0; // الخطوة الحالية

  @override
  void initState() {
    super.initState();
    _lessonFuture = fetchLesson(); // جلب بيانات الدرس عند تهيئة الحالة
  }

  /// جلب بيانات الدرس من قاعدة البيانات
  Future<Lesson> fetchLesson() async {
    final dbHelper = DatabaseHelper(); // إنشاء مساعد قاعدة البيانات
    Map<String, dynamic>? lessonMap = await dbHelper
        .getLessonById(widget.lessonId); // جلب بيانات الدرس من قاعدة البيانات
    return Lesson.fromJson(lessonMap!); // تحويل البيانات إلى نموذج درس
  }

  @override
  void dispose() {
    _youtubePlayerController
        ?.close(); // إغلاق متحكم الفيديو عند التخلص من الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('تفاصيل الدرس'), // عنوان الصفحة
      ),
      body: FutureBuilder<Lesson>(
        future: _lessonFuture, // المستقبِل الذي يحمل بيانات الدرس
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // عرض مؤشر الانتظار إذا كانت البيانات قيد التحميل
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // عرض رسالة خطأ إذا حدث خطأ أثناء الجلب
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text(
                    'لا يوجد بيانات للدرس')); // عرض رسالة إذا لم تكن هناك بيانات
          } else {
            Lesson lesson = snapshot.data!; // بيانات الدرس
            List<Widget> steps = [
              buildStep(
                lesson.lessonFirstTitle, // عنوان الخطوة الأولى
                lesson.lessonFirstContent, // محتوى الخطوة الأولى
                lesson.lessonFirstImage, // صورة الخطوة الأولى
              ),
              buildStep(
                lesson.lessonSecondTitle, // عنوان الخطوة الثانية
                lesson.lessonSecondContent, // محتوى الخطوة الثانية
                lesson.lessonSecondImage, // صورة الخطوة الثانية
              ),
              buildVideoPlayer(lesson.lessonLink), // مشغل الفيديو للدرس
            ];
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16.0), // إضافة مسافة حول المحتوى
                      child: steps[_currentStep], // عرض الخطوة الحالية
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // توزيع الأزرار بالتساوي
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--; // الانتقال إلى الخطوة السابقة
                          });
                        },
                        child: const Text('السابق'), // زر الخطوة السابقة
                      ),
                    const Spacer(), // إضافة مساحة فارغة بين الأزرار
                    if (_currentStep < steps.length - 1)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentStep++; // الانتقال إلى الخطوة التالية
                          });
                        },

                        child: const Text('التالي'), // زر الخطوة التالية
                      ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

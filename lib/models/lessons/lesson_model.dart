// ignore_for_file: non_constant_identifier_names

class Lesson {
  final int lesson_id;
  final String lesson_name;

  Lesson({required this.lesson_id, required this.lesson_name});

  // إنشاء كائن Lesson من JSON
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lesson_id: json['lesson_id'],
      lesson_name: json['lesson_name'],
    );
  }
}

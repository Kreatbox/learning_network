class Lesson {
  final int lessonId;
  final String lessonName;
  final String lessonFirstTitle;
  final String lessonFirstContent;
  final String lessonSecondTitle;
  final String lessonSecondContent;
  final String lessonThirdTitle;
  final String lessonThirdContent;
  final String lessonLink;

  Lesson({
    required this.lessonId,
    required this.lessonName,
    required this.lessonFirstTitle,
    required this.lessonFirstContent,
    required this.lessonSecondTitle,
    required this.lessonSecondContent,
    required this.lessonThirdTitle,
    required this.lessonThirdContent,
    required this.lessonLink,
  });

  // دالة لتحويل البيانات من JSON إلى كائن درس
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'],
      lessonName: json['lesson_name'],
      lessonFirstTitle: json['lesson_first_title'],
      lessonFirstContent: json['lesson_first_content'],
      lessonSecondTitle: json['lesson_second_title'],
      lessonSecondContent: json['lesson_second_content'],
      lessonThirdTitle: json['lesson_third_title'],
      lessonThirdContent: json['lesson_third_content'],
      lessonLink: json['lesson_link'],
    );
  }

  // دالة لتحويل كائن درس إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lesson_name': lessonName,
      'lesson_first_title': lessonFirstTitle,
      'lesson_first_content': lessonFirstContent,
      'lesson_second_title': lessonSecondTitle,
      'lesson_second_content': lessonSecondContent,
      'lesson_third_title': lessonThirdTitle,
      'lesson_third_content': lessonThirdContent,
      'lesson_link': lessonLink,
    };
  }
}

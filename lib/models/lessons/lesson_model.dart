class Lesson {
  final int lessonId;
  final String lessonName;
  final String lessonFirstTitle;
  final String lessonFirstContent;
  final String lessonFirstImage;
  final String lessonSecondTitle;
  final String lessonSecondContent;
  final String lessonSecondImage;
  final String lessonLink;

  Lesson({
    required this.lessonId,
    required this.lessonName,
    required this.lessonFirstTitle,
    required this.lessonFirstContent,
    required this.lessonFirstImage,
    required this.lessonSecondTitle,
    required this.lessonSecondContent,
    required this.lessonSecondImage,
    required this.lessonLink,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'],
      lessonName: json['lesson_name'],
      lessonFirstTitle: json['lesson_first_title'],
      lessonFirstContent: json['lesson_first_content'],
      lessonFirstImage: json['lesson_first_image'],
      lessonSecondTitle: json['lesson_second_title'],
      lessonSecondContent: json['lesson_second_content'],
      lessonSecondImage: json['lesson_second_image'],
      lessonLink: json['lesson_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lesson_name': lessonName,
      'lesson_first_title': lessonFirstTitle,
      'lesson_first_content': lessonFirstContent,
      'lesson_first_image': lessonFirstImage,
      'lesson_second_title': lessonSecondTitle,
      'lesson_second_content': lessonSecondContent,
      'lesson_second_image': lessonSecondImage,
      'lesson_link': lessonLink,
    };
  }
}

class Lesson {
  final int lessonId;
  final String lessonName;
  final String lessonFirstTitle;
  final String lessonFirstContent;
  final String lessonFirstImage;
  final String lessonSecondTitle;
  final String lessonSecondContent;
  final String lessonSecondImage;
  final String lessonThirdTitle;
  final String lessonThirdContent;
  final String lessonThirdImage;
  final String lessonFourthTitle;
  final String lessonFourthContent;
  final String lessonFourthImage;
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
    required this.lessonThirdTitle,
    required this.lessonThirdContent,
    required this.lessonThirdImage,
    required this.lessonFourthTitle,
    required this.lessonFourthContent,
    required this.lessonFourthImage,
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
      lessonThirdTitle: json['lesson_third_title'],
      lessonThirdContent: json['lesson_third_content'],
      lessonThirdImage: json['lesson_third_image'],
      lessonFourthTitle: json['lesson_fourth_title'],
      lessonFourthContent: json['lesson_fourth_content'],
      lessonFourthImage: json['lesson_fourth_image'],
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
      'lesson_third_title': lessonThirdTitle,
      'lesson_third_content': lessonThirdContent,
      'lesson_third_image': lessonThirdImage,
      'lesson_fourth_title': lessonFourthTitle,
      'lesson_fourth_content': lessonFourthContent,
      'lesson_fourth_image': lessonFourthImage,
      'lesson_link': lessonLink,
    };
  }
}

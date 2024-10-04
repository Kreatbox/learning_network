class Test {
  final int testId;
  final int lessonId;
  final String testName;
  final double scorePercentage;
  final int attempts;

  Test({
    required this.testId,
    required this.lessonId,
    required this.testName,
    required this.scorePercentage,
    required this.attempts,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testId: json['test_id'],
      lessonId: json['lesson_id'],
      testName: json['test_name'],
      scorePercentage: json['score_percentage'] ?? 0.0,
      attempts: json['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test_id': testId,
      'lesson_id': lessonId,
      'test_name': testName,
      'score_percentage': scorePercentage,
      'attempts': attempts,
    };
  }
}

class Test {
  final int testId;
  final int lessonId;
  final String testName;

  Test({required this.testId, required this.lessonId, required this.testName});

  // إنشاء كائن Test من JSON
  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testId: json['test_id'],
      lessonId: json['lesson_id'],
      testName: json['test_name'],
    );
  }
}

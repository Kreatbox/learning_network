class Question {
  final int questionId;
  final String questionText;
  final List<String> choices;
  final int correctChoice;
  final String reason;
  final int state;

  Question({
    required this.questionId,
    required this.questionText,
    required this.choices,
    required this.correctChoice,
    required this.reason,
    required this.state,
  });

  // إنشاء كائن Question من JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      questionText: json['question_text'],
      choices: [
        json['choice1'],
        json['choice2'],
        json['choice3'],
        json['choice4']
      ],
      correctChoice: json['correct_choice'],
      reason: json['reason'],
      state: json['state'],
    );
  }
}

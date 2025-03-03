class Question {
  int? questionId;
  String? question;
  String? ansDescription;
  List<QuizQuestionOptionMobBean>? quizQuestionOptionMobBean;


  Question(
      {this.questionId,
        this.question,
        this.ansDescription,
        this.quizQuestionOptionMobBean});

  Question.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    question = json['question'];
    ansDescription = json['ansDescription'];
    if (json['quizQuestionOptionMobBean'] != null) {
      quizQuestionOptionMobBean = <QuizQuestionOptionMobBean>[];
      json['quizQuestionOptionMobBean'].forEach((v) {
        quizQuestionOptionMobBean!
            .add(new QuizQuestionOptionMobBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['question'] = this.question;
    data['ansDescription'] = this.ansDescription;
    if (this.quizQuestionOptionMobBean != null) {
      data['quizQuestionOptionMobBean'] =
          this.quizQuestionOptionMobBean!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizQuestionOptionMobBean {
  String? name;
  bool? isOption;

  QuizQuestionOptionMobBean({this.name, this.isOption});

  QuizQuestionOptionMobBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isOption = json['isOption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isOption'] = this.isOption;
    return data;
  }
}

class Student {
  int id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    var subjectsList = (json['subjects'] as List)
        .map((subjectJson) => Subject.fromJson(subjectJson))
        .toList();
    return Student(
      id: json['id'],
      name: json['name'],
      subjects: subjectsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}

class Subject {
  String name;
  List<int> scores;

  Subject({required this.name, required this.scores});

  factory Subject.fromJson(Map<String, dynamic> json) {
    List<int> scoresList =
        (json['scores'] as List).map((score) => score as int).toList();
    return Subject(
      name: json['name'],
      scores: scoresList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scores': scores,
    };
  }
}

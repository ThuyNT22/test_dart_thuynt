import 'dart:convert';
import 'dart:io';
import '../entity/student.dart';

class StudentService {
  final String filePath = 'data/Student.json';
  List<Student> students = [];

  StudentService() {
    loadData();
  }

  void loadData() {
    var file = File(filePath);
    if (file.existsSync()) {
      var jsonData = file.readAsStringSync();
      var data = jsonDecode(jsonData) as Map<String, dynamic>;
      students = (data['students'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList();
    }
  }

  void saveData() {
    var data = {
      'students': students.map((student) => student.toJson()).toList()
    };
    var file = File(filePath);
    file.writeAsStringSync(jsonEncode(data));
  }

  void displayAllStudents() {
    for (var student in students) {
      print('ID: ${student.id}, Name: ${student.name}');
      for (var subject in student.subjects) {
        print('Subject: ${subject.name}, Scores: ${subject.scores.join(", ")}');
      }
    }
  }

  void addStudent(Student student) {
    students.add(student);
    saveData();
  }

  void editStudent(int id, String newName, List<Subject> newSubjects) {
    var student = searchStudentById(id);
    if (student != null) {
      student.name = newName;
      student.subjects = newSubjects;
      saveData();
    } else {
      print("No student found with ID $id");
    }
  }

  Student? searchStudentById(int id) {
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  Student? searchStudentByNameOrId({String? name, int? id}) {
    try {
      return students.firstWhere((student) =>
          (name != null && student.name == name) ||
          (id != null && student.id == id));
    } catch (e) {
      return null;
    }
  }
}

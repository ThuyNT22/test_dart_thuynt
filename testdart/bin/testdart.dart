import 'dart:io';
import 'package:testdart/entity/student.dart';
import 'package:testdart/services/student_service.dart';

void main() {
  var studentService = StudentService();

  while (true) {
    print('\nChọn một chức năng:');
    print('1: Hiển thị toàn bộ sinh viên');
    print('2: Thêm sinh viên');
    print('3: Sửa thông tin sinh viên');
    print('4: Tìm kiếm sinh viên theo Tên hoặc ID');
    print('5: Xóa sinh viên');
    print('6: Thoát');
    stdout.write('Lựa chọn của bạn: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        studentService.displayAllStudents();
        break;
      case '2':
        addStudent(studentService);
        break;
      case '3':
        editStudent(studentService);
        break;
      case '4':
        searchStudent(studentService);
        break;
      case '5':
        deleteStudent(studentService);
        break;
      case '6':
        exit(0);
      default:
        print('Lựa chọn không hợp lệ. Vui lòng chọn lại.');
    }
  }
}

void addStudent(StudentService studentService) {
  stdout.write('Nhập ID sinh viên: ');
  int id = int.parse(stdin.readLineSync()!);
  stdout.write('Nhập tên sinh viên: ');
  String name = stdin.readLineSync()!;

  List<Subject> subjects = [];
  while (true) {
    stdout.write('Nhập tên môn học (hoặc nhấn Enter để kết thúc): ');
    String subjectName = stdin.readLineSync()!;
    if (subjectName.isEmpty) break;

    stdout.write('Nhập điểm thi (phân cách bằng dấu phẩy): ');
    List<int> scores = stdin
        .readLineSync()!
        .split(',')
        .map((s) => int.parse(s.trim()))
        .toList();

    subjects.add(Subject(name: subjectName, scores: scores));
  }

  var newStudent = Student(id: id, name: name, subjects: subjects);
  studentService.addStudent(newStudent);
  print('Đã thêm sinh viên.');
}

void editStudent(StudentService studentService) {
  stdout.write('Nhập ID sinh viên cần sửa: ');
  int id = int.parse(stdin.readLineSync()!);

  var student = studentService.searchStudentByNameOrId(id: id);
  if (student == null) {
    print('Không tìm thấy sinh viên.');
    return;
  }

  stdout.write('Nhập tên mới cho sinh viên (để trống nếu không đổi): ');
  String newName = stdin.readLineSync()!;
  if (newName.isEmpty) {
    newName = student.name;
  }

  List<Subject> newSubjects = [];
  while (true) {
    stdout.write('Nhập tên môn học (hoặc nhấn Enter để kết thúc): ');
    String subjectName = stdin.readLineSync()!;
    if (subjectName.isEmpty) break;

    stdout.write('Nhập điểm thi (phân cách bằng dấu phẩy): ');
    List<int> scores = stdin
        .readLineSync()!
        .split(',')
        .map((s) => int.parse(s.trim()))
        .toList();

    newSubjects.add(Subject(name: subjectName, scores: scores));
  }

  studentService.editStudent(id, newName, newSubjects);
  print('Đã sửa thông tin sinh viên.');
}

void searchStudent(StudentService studentService) {
  stdout.write('Nhập tên hoặc ID sinh viên cần tìm: ');
  String searchQuery = stdin.readLineSync()!;

  var student = int.tryParse(searchQuery) != null
      ? studentService.searchStudentByNameOrId(id: int.parse(searchQuery))
      : studentService.searchStudentByNameOrId(name: searchQuery);

  if (student != null) {
    print('Tìm thấy sinh viên:');
    print('ID: ${student.id}, Name: ${student.name}');
    for (var subject in student.subjects) {
      print('Subject: ${subject.name}, Scores: ${subject.scores.join(", ")}');
    }
  } else {
    print('Không tìm thấy sinh viên.');
  }
}

void deleteStudent(StudentService studentService) {
  stdout.write('Nhập ID sinh viên cần xóa: ');
  int id = int.parse(stdin.readLineSync()!);

  var student = studentService.searchStudentByNameOrId(id: id);
  if (student == null) {
    print('Không tìm thấy sinh viên.');
    return;
  }

  studentService.students.remove(student);
  studentService.saveData();
  print('Đã xóa sinh viên.');
}

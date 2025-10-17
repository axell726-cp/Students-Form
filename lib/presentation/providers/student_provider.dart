import 'package:flutter/material.dart';
import 'package:flutter_application_students_form/domain/usecases/get_students.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/student.dart';
import '../../domain/usecases/register_student.dart';
import '../../core/result.dart';

class StudentProvider extends ChangeNotifier {
  final RegisterStudent registerStudentUseCase;
  final GetStudents getStudentsUseCase;
  final DeleteStudent? deleteStudentUseCase;

  bool isLoading = false;
  String? lastError;
  List<Student> _students = [];
  List<Student> get students => _students;

  StudentProvider({
    required this.registerStudentUseCase,
    required this.getStudentsUseCase,
    this.deleteStudentUseCase,
  }) {
    loadStudents();
  }

  Future<bool> register({
    required String name,
    required String email,
    required int age,
    required String career,
    required int cicle,
    BuildContext? context,
  }) async {
    isLoading = true;
    lastError = null;
    notifyListeners();

    final student = Student(
      id: const Uuid().v4(),
      name: name.trim(),
      email: email.trim(),
      age: age,
      career: career.trim(),
      cicle: cicle,
    );

    final Result<void> result = await registerStudentUseCase(student);
    isLoading = false;

    if (result.isSuccess) {
      // Refresh list to reflect newly added student
      await loadStudents();
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Estudiante registrado')));
      }
      notifyListeners();
      return true;
    } else {
      lastError = result.error;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(lastError ?? 'Error')));
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(String id, {BuildContext? context}) async {
    if (deleteStudentUseCase == null) return false;
    isLoading = true;
    notifyListeners();
    final result = await deleteStudentUseCase!(id);
    isLoading = false;
    if (result.isSuccess) {
      await loadStudents();
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Estudiante eliminado')));
      }
      return true;
    } else {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.error ?? 'Error')));
      }
      return false;
    }
  }

  Future<void> loadStudents() async {
    try {
      _students = await getStudentsUseCase();
    } catch (e) {
      debugPrint('Error al cargar estudiantes: $e');
      _students = [];
    }
    notifyListeners();
  }
}

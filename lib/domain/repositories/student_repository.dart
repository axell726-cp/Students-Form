import '../../core/result.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<Result<void>> registerStudent(Student student);
  Future<Result<List<Student>>> getAllStudents();
  Future<Result<void>> deleteStudent(String id);
}

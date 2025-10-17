import '../../core/result.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_datasource.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource local;

  StudentRepositoryImpl({required this.local});

  @override
  Future<Result<void>> registerStudent(Student student) async {
    try {
      await local.saveStudent(student);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Error al guardar estudiante: $e');
    }
  }

  @override
  Future<Result<List<Student>>> getAllStudents() async {
    try {
      final students = await local.fetchAll();
      return Result.success(students);
    } catch (e) {
      return Result.failure('Error al obtener estudiantes: $e');
    }
  }

  @override
  Future<Result<void>> deleteStudent(String id) async {
    try {
      await local.delete(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Error al eliminar estudiante: $e');
    }
  }
}

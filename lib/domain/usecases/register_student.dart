import '../entities/student.dart';
import '../repositories/student_repository.dart';
import '../../core/result.dart';

class RegisterStudent {
  final StudentRepository repository;

  RegisterStudent(this.repository);

  Future<Result<void>> call(Student student) async {
    // Aquí podrías añadir reglas de negocio (p. ej. verificar duplicados)
    return await repository.registerStudent(student);
  }
}

class DeleteStudent {
  final StudentRepository repository;

  DeleteStudent(this.repository);

  Future<Result<void>> call(String id) async {
    return await repository.deleteStudent(id);
  }
}

import 'package:flutter/foundation.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

class GetStudents {
  final StudentRepository repository;
  GetStudents(this.repository);

  Future<List<Student>> call() async {
    final result = await repository.getAllStudents();

    if (result.isSuccess && result.data != null) {
      return result.data!;
    } else {
      // Si hubo error o no hay datos, retornamos lista vacía
      debugPrint('❌ Error al obtener estudiantes: ${result.error}');
      return [];
    }
  }
}

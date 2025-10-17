import 'package:flutter/foundation.dart';
import '../../domain/entities/student.dart';

class StudentLocalDataSource {
  final List<Student> _storage = [];

  Future<void> saveStudent(Student student) async {
    // Simula latencia
    await Future.delayed(const Duration(milliseconds: 200));
    _storage.add(student);
    debugPrint('🟩 Guardado en memoria: ${student.name}');
  }

  Future<List<Student>> fetchAll() async {
    debugPrint('📦 Recuperando ${_storage.length} estudiantes');
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_storage);
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    _storage.removeWhere((s) => s.id == id);
    debugPrint('🟥 Eliminado en memoria: $id');
  }
}

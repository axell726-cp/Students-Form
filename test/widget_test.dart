// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_application_students_form/core/result.dart';
import 'package:flutter_application_students_form/domain/entities/student.dart';
import 'package:flutter_application_students_form/domain/repositories/student_repository.dart';
import 'package:flutter_application_students_form/domain/usecases/get_students.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_students_form/main.dart';
import 'package:flutter_application_students_form/domain/usecases/register_student.dart';

class MockStudentsRepository implements StudentRepository {
  @override
  Future<Result<void>> registerStudent(student) async {
    return Result.success(null);
  }

  @override
  Future<Result<List<Student>>> getAllStudents() async {
    return Result.success([]);
  }

  @override
  Future<Result<void>> deleteStudent(String id) async {
    return Result.success(null);
  }
}

void main() {
  testWidgets('Registro y obtención de estudiantes (test básico)', (
    WidgetTester tester,
  ) async {
    // 🧱 Setup inicial (mock + casos de uso)
    final mockRepo = MockStudentsRepository();
    final registerUseCase = RegisterStudent(mockRepo);
    final getStudentsUseCase = GetStudents(mockRepo);

    // 🧩 Construimos el widget principal con ambos use cases
    await tester.pumpWidget(
      MyApp(
        registerUseCase: registerUseCase,
        getStudentsUseCase: getStudentsUseCase,
      ),
    );

    // ✅ Verificamos que se cargue la página principal
    expect(find.text('Registrar Estudiante'), findsOneWidget);

    // 💡 Aquí podrías simular interacción si tuvieras TextFields y botón "Registrar"
    // Ejemplo:
    // await tester.enterText(find.byKey(Key('nameField')), 'Axell');
    // await tester.tap(find.byKey(Key('submitButton')));
    // await tester.pump();

    // Por ahora, solo validamos que el widget principal cargue correctamente
    expect(find.byType(MyApp), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_application_students_form/domain/usecases/get_students.dart';
import 'package:provider/provider.dart';
import 'data/datasources/student_local_datasource.dart';
import 'data/repositories/student_repository_impl.dart';
import 'domain/usecases/register_student.dart';
import 'presentation/providers/student_provider.dart';
import 'presentation/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final local = StudentLocalDataSource();
  final repo = StudentRepositoryImpl(local: local);
  final register = RegisterStudent(repo);
  final getStudent = GetStudents(repo);
  final deleteStudent = DeleteStudent(repo);

  runApp(MyApp(
    registerUseCase: register,
    getStudentsUseCase: getStudent,
    deleteStudentUseCase: deleteStudent,
  ));
}

class MyApp extends StatelessWidget {
  final RegisterStudent registerUseCase;
  final GetStudents getStudentsUseCase;
  final DeleteStudent? deleteStudentUseCase;
  const MyApp({
    super.key,
    required this.registerUseCase,
    required this.getStudentsUseCase,
    this.deleteStudentUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StudentProvider(
            registerStudentUseCase: registerUseCase,
            getStudentsUseCase: getStudentsUseCase,
            deleteStudentUseCase: deleteStudentUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Registro Estudiantes',
        theme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                primary: Colors.greenAccent.shade400,
                secondary: Colors.green.shade600,
              ),
          scaffoldBackgroundColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
          // cardTheme removed to keep compatibility across Flutter versions
          textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        home: const RegisterPage(),
      ),
    );
  }
}

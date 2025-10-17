import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../widgets/default_text_field.dart';
import 'package:flutter_application_students_form/presentation/pages/student_list_page.dart';

import '../providers/student_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _cicleCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _careerCtrl.dispose();
    _cicleCtrl.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Correo inválido';
    }
    return null;
  }

  String? _validateCicle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El ciclo es obligatorio';
    }
    if (int.tryParse(value) == null) {
      return 'Debe ser un número';
    }
    return null;
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      age: 18, // Ajusta si tienes el campo
      career: _careerCtrl.text.trim(),
      cicle: int.parse(_cicleCtrl.text.trim()),
      context: context,
    );
    if (mounted) {
      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _emailCtrl.clear();
      _careerCtrl.clear();
      _cicleCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<StudentProvider>(context).isLoading;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/img/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.45),
              colorBlendMode: BlendMode.darken,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.60),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.greenAccent,
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Registro de Estudiantes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 18),
                            DefaultTextField(
                              label: 'Nombre completo',
                              icon: Icons.person,
                              controller: _nameCtrl,
                              validator: _validateNotEmpty,
                            ),
                            const SizedBox(height: 10),
                            DefaultTextField(
                              label: 'Correo electrónico',
                              icon: Icons.email,
                              controller: _emailCtrl,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            DefaultTextField(
                              label: 'Carrera',
                              icon: Icons.work,
                              controller: _careerCtrl,
                              validator: _validateNotEmpty,
                            ),
                            const SizedBox(height: 10),
                            DefaultTextField(
                              label: 'Ciclo',
                              icon: Icons.confirmation_number,
                              controller: _cicleCtrl,
                              validator: _validateCicle,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: isLoading ? null : _onSubmit,
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                label: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : const Text(
                                        'Registrar',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentListPage()),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}

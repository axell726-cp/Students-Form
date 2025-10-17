import 'package:flutter/material.dart';
import 'package:flutter_application_students_form/presentation/pages/student_list_page.dart';
import 'package:provider/provider.dart';
import '../widgets/default_text_field.dart';
import '../providers/student_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _cicleCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    _careerCtrl.dispose();
    _cicleCtrl.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? v) {
    return (v == null || v.trim().isEmpty) ? 'Campo requerido' : null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email requerido';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(v.trim()) ? null : 'Email inválido';
  }

  String? _validateCicle(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ciclo requerido';
    final cicle = int.tryParse(v);
    if (cicle == null) return 'Número inválido';
    if (cicle < 1 || cicle > 10) return 'Ciclo entre 1 y 10';
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<StudentProvider>();

    final age = int.tryParse(_ageCtrl.text);
    final cicle = int.tryParse(_cicleCtrl.text);

    if (age == null || cicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edad y ciclo deben ser numéricos')),
      );
      return;
    }
    final success = await provider.register(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      age: age,
      career: _careerCtrl.text,
      cicle: cicle,
    );

    if (success && mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registro exitoso 🎉'),
          content: const Text('El estudiante fue registrado correctamente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cierra el diálogo
              child: const Text('Registrar otro'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentListPage()),
                );
              },
              child: const Text('Ver lista'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // 🔹 Autocompletar campos, pero NO registrar aún
    _nameCtrl.text = "Tester Bot";
    _emailCtrl.text = "tester@example.com";
    _ageCtrl.text = "21";
    _careerCtrl.text = "Ingeniería de Sistemas";
    _cicleCtrl.text = "6";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<StudentProvider>().isLoading;

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
              color: Colors.black.withValues(alpha: 0.45),
              colorBlendMode: BlendMode.darken,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    // Card-like elevated panel with strong contrast for readability
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.greenAccent,
                            size: 72,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Registrar Estudiante',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 16),
                        DefaultTextField(
                          label: 'Nombre completo',
                          icon: Icons.person,
                          controller: _nameCtrl,
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 8),
                        DefaultTextField(
                          label: 'Correo electrónico',
                          icon: Icons.email,
                          controller: _emailCtrl,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        DefaultTextField(
                          label: 'Carrera',
                          icon: Icons.work,
                          controller: _careerCtrl,
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 8),
                        DefaultTextField(
                          label: 'Ciclo',
                          icon: Icons.confirmation_number,
                          controller: _cicleCtrl,
                          validator: _validateCicle,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _onSubmit,
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : const Text('Registrar', style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ),
                      ],
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

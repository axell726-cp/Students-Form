import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid using BuildContext across async gaps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final students = provider.students;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Estudiantes'), elevation: 2),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.inbox, size: 56, color: Colors.white54),
                  SizedBox(height: 12),
                  Text(
                    'No hay estudiantes registrados 😅',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final s = students[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.greenAccent.shade700
                              .withValues(alpha: 0.85),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          s.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.2,
                          ),
                        ),
                        subtitle: Text(
                          '${s.career}  •  Ciclo ${s.cicle}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) => ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 16,
                                    sigmaY: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.copy,
                                            color: Colors.white70,
                                          ),
                                          title: const Text(
                                            'Copiar nombre',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          title: const Text(
                                            'Eliminar',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () async {
                                            final outerContext = context;
                                            final provider =
                                                Provider.of<StudentProvider>(
                                                  outerContext,
                                                  listen: false,
                                                );
                                            final confirmed = await showDialog<bool>(
                                              context: outerContext,
                                              builder: (dialogCtx) => AlertDialog(
                                                backgroundColor:
                                                    Colors.grey[900],
                                                title: const Text(
                                                  'Confirmar eliminación',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: const Text(
                                                  '¿Deseas eliminar este estudiante?',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          dialogCtx,
                                                        ).pop(false),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          dialogCtx,
                                                        ).pop(true),
                                                    child: const Text('Sí'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (!mounted) return;
                                            if (confirmed == true) {
                                              Navigator.pop(context);
                                              await provider.deleteStudent(
                                                s.id,
                                                context: context,
                                              );
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.share,
                                            color: Colors.white70,
                                          ),
                                          title: const Text(
                                            'Compartir',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
        child: const Icon(Icons.home),
        tooltip: 'Volver a registrar',
      ),
    );
  }
}

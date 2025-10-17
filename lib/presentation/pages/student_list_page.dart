import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
        elevation: 2,
      ),
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
                    return Card(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade600,
                          child: Text(
                            s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(s.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: Text('${s.career} — Ciclo ${s.cicle}', style: const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white70),
                          onPressed: () {
                            // small menu placeholder
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) => Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.copy, color: Colors.white70),
                                      title: const Text('Copiar nombre', style: TextStyle(color: Colors.white)),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete, color: Colors.redAccent),
                                      title: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                      onTap: () async {
                                        // capture references to avoid async gaps warnings
                                        final outerContext = context;
                                        final provider = Provider.of<StudentProvider>(outerContext, listen: false);
                                        // Confirm before deleting using a dialog with its own ctx
                                        final confirmed = await showDialog<bool>(
                                          context: outerContext,
                                          builder: (dialogCtx) => AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: const Text('Confirmar eliminación', style: TextStyle(color: Colors.white)),
                                            content: const Text('¿Deseas eliminar este estudiante?', style: TextStyle(color: Colors.white70)),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(dialogCtx).pop(false), child: const Text('No')),
                                              TextButton(onPressed: () => Navigator.of(dialogCtx).pop(true), child: const Text('Sí')),
                                            ],
                                          ),
                                        );

                                        if (!mounted) return;
                                        if (confirmed == true) {
                                          // close the bottom sheet
                                          Navigator.pop(context);
                                          // perform delete safely using captured provider and current context
                                          await provider.deleteStudent(s.id, context: context);
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.share, color: Colors.white70),
                                      title: const Text('Compartir', style: TextStyle(color: Colors.white)),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

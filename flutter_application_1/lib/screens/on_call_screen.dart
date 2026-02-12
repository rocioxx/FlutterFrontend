import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import 'package:provider/provider.dart';
import '../providers/teacher_provider.dart';

class OnCallScreen extends StatefulWidget {
  const OnCallScreen({super.key});

  @override
  State<OnCallScreen> createState() => _OnCallScreenState();
}

class _OnCallScreenState extends State<OnCallScreen> {
  // Mock 'available' status for teachers
  final Map<String, bool> _availability = {
    '1': true,
    '2': false,
    '3': true,
    '4': true,
  };

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);

    if (teacherProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (teacherProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${teacherProvider.error}'),
            ElevatedButton(
              onPressed: () => teacherProvider.loadTeachers(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final teachers = teacherProvider.teachers;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Profesores Disponibles',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Profesores libres para guardias',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Todos'),
                      selected: true,
                      onSelected: (bool selected) {},
                    ),
                    FilterChip(
                      label: const Text('Dpto. Matemáticas'),
                      selected: false,
                      onSelected: (bool selected) {},
                    ),
                    FilterChip(
                      label: const Text('Dpto. Ciencias'),
                      selected: false,
                      onSelected: (bool selected) {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final teacher = teachers[index];
              final isAvailable =
                  _availability[teacher.id] ??
                  true; // Default to true for new ones

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(teacher.avatarUrl),
                  ),
                  title: Text(teacher.name),
                  subtitle: Text(teacher.subject),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isAvailable ? 'Disponible' : 'Ocupado',
                      style: TextStyle(
                        color: isAvailable
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    _showAssignDialog(context, teacher);
                  },
                ),
              );
            }, childCount: teachers.length),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Asignar a ${teacher.name}?'),
        content: const Text(
          '¿Quieres asignar a este profesor para una guardia?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              // Logic to assign teacher would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${teacher.name} asignado a guardia')),
              );
            },
            child: const Text('Asignar'),
          ),
        ],
      ),
    );
  }
}

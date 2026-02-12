import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/teacher_provider.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  final List<Absence> _absences = List.from(mockAbsences);

  void _addNewAbsence(Absence absence) {
    setState(() {
      _absences.add(absence);
    });
  }

  void _showAddAbsenceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddAbsenceForm(onSave: _addNewAbsence),
    );
  }

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

    return Scaffold(
      body: _absences.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay ausencias pendientes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _absences.length,
              itemBuilder: (context, index) {
                final absence = _absences[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(absence.teacher.avatarUrl),
                    ),
                    title: Text(
                      absence.teacher.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMM d, y').format(absence.date)),
                        Text(
                          absence.reason,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        if (absence.isCovered)
                          Chip(
                            label: Text('Cubierto por: ${absence.coveredBy}'),
                            backgroundColor: Colors.green.shade100,
                            labelStyle: const TextStyle(fontSize: 12),
                            visualDensity: VisualDensity.compact,
                          )
                        else
                          Chip(
                            label: const Text('Sin Cubrir'),
                            backgroundColor: Colors.red.shade100,
                            labelStyle: const TextStyle(fontSize: 12),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAbsenceSheet,
        label: const Text('Reportar Ausencia'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class AddAbsenceForm extends StatefulWidget {
  final Function(Absence) onSave;

  const AddAbsenceForm({super.key, required this.onSave});

  @override
  State<AddAbsenceForm> createState() => _AddAbsenceFormState();
}

class _AddAbsenceFormState extends State<AddAbsenceForm> {
  final _formKey = GlobalKey<FormState>();
  Teacher? _selectedTeacher;
  DateTime _selectedDate = DateTime.now();
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reportar Nueva Ausencia',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Teacher>(
              decoration: const InputDecoration(
                labelText: 'Profesor',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedTeacher,
              items: Provider.of<TeacherProvider>(context, listen: false)
                  .teachers
                  .map((t) {
                    return DropdownMenuItem(value: t, child: Text(t.name));
                  })
                  .toList(),
              onChanged: (value) => setState(() => _selectedTeacher = value),
              validator: (value) =>
                  value == null ? 'Por favor seleccione un profesor' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                child: Text(DateFormat('MMM d, y').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingrese un motivo'
                  : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newAbsence = Absence(
                      id: DateTime.now().toString(),
                      teacher: _selectedTeacher!,
                      date: _selectedDate,
                      reason: _reasonController.text,
                    );
                    widget.onSave(newAbsence);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enviar Reporte'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

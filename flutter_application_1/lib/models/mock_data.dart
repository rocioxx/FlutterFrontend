import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  final String subject;
  final String avatarUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.avatarUrl,
  });
}

class Absence {
  final String id;
  final Teacher teacher;
  final DateTime date;
  final String reason;
  final bool isCovered;
  final String? coveredBy;

  Absence({
    required this.id,
    required this.teacher,
    required this.date,
    required this.reason,
    this.isCovered = false,
    this.coveredBy,
  });
}

class ClassSession {
  final String id;
  final String subject;
  final String group;
  final String room;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday

  ClassSession({
    required this.id,
    required this.subject,
    required this.group,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
  });
}

// Mock Data
final List<Teacher> mockTeachers = [
  Teacher(
    id: '1',
    name: 'Maria Garcia',
    subject: 'Matemáticas',
    avatarUrl: 'https://i.pravatar.cc/150?u=1',
  ),
  Teacher(
    id: '2',
    name: 'John Doe',
    subject: 'Historia',
    avatarUrl: 'https://i.pravatar.cc/150?u=2',
  ),
  Teacher(
    id: '3',
    name: 'Ana Lopez',
    subject: 'Física',
    avatarUrl: 'https://i.pravatar.cc/150?u=3',
  ),
  Teacher(
    id: '4',
    name: 'Carlos Ruiz',
    subject: 'Inglés',
    avatarUrl: 'https://i.pravatar.cc/150?u=4',
  ),
];

final List<Absence> mockAbsences = [
  Absence(
    id: '1',
    teacher: mockTeachers[0],
    date: DateTime.now(),
    reason: 'Cita Médica',
    isCovered: false,
  ),
  Absence(
    id: '2',
    teacher: mockTeachers[1],
    date: DateTime.now().subtract(const Duration(days: 1)),
    reason: 'Asuntos Propios',
    isCovered: true,
    coveredBy: 'Carlos Ruiz',
  ),
];

final List<ClassSession> mockSchedule = [
  ClassSession(
    id: '1',
    subject: 'Math',
    group: '1A',
    room: '101',
    startTime: const TimeOfDay(hour: 8, minute: 0),
    endTime: const TimeOfDay(hour: 9, minute: 0),
    dayOfWeek: 1,
  ),
  ClassSession(
    id: '2',
    subject: 'Math',
    group: '2B',
    room: '102',
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 0),
    dayOfWeek: 1,
  ),
  ClassSession(
    id: '3',
    subject: 'Math',
    group: '3C',
    room: '103',
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    dayOfWeek: 1,
  ),
];

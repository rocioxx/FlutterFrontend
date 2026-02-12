import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../services/teacher_service.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _teachers = [];
  bool _isLoading = false;
  String? _error;

  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final TeacherService _service = TeacherService();

  Future<void> loadTeachers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _teachers = await _service.fetchTeachers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

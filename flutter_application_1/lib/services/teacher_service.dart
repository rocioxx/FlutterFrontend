import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/mock_data.dart';

class TeacherService {
  static const String _baseUrl = 'https://randomuser.me/api?results=25';

  Future<List<Teacher>> fetchTeachers() async {
    String url = _baseUrl;

    // Workaround for CORS issues on Flutter Web during development
    if (kIsWeb) {
      url = 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}';
    }

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        final subjects = [
          'Matemáticas',
          'Historia',
          'Física',
          'Inglés',
          'Biología',
          'Química',
          'Lengua',
          'Arte',
        ];

        return results.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          return Teacher(
            id: user['login']['uuid'],
            name: '${user['name']['first']} ${user['name']['last']}',
            subject: subjects[index % subjects.length],
            avatarUrl: user['picture']['large'],
          );
        }).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching teachers: $e');
      rethrow; // Rethrow to show the error in UI instead of silent fallback
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/task.dart';

class ApiService {
  // Для AVD используйте 10.0.2.2
  static const baseUrl = 'http://10.0.2.2:8000';

  // Projects
  static Future<List<Project>> fetchProjects() async {
    final res = await http.get(Uri.parse('$baseUrl/projects'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Project.fromJson(e)).toList();
    }
    throw Exception('Failed to load projects');
  }

  static Future<Project> createProject(Project p) async {
    final res = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Project.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create project: ${res.body}');
  }

  // Tasks
  static Future<List<Task>> fetchTasks({int? projectId}) async {
    final url = projectId != null ? '$baseUrl/tasks?project_id=$projectId' : '$baseUrl/tasks';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Task.fromJson(e)).toList();
    }
    throw Exception('Failed to load tasks');
  }

  static Future<Task> createTask(Task t) async {
    final res = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(t.toJson()),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Task.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create task');
  }
}

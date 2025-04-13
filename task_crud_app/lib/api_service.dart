// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // const String baseUrl = 'http://172.22.144.1:8000/api/tasks/'; // Adjust for device
// //
// // class Task {
// //   final int id;
// //   final String title;
// //   final String description;
// //
// //   Task({required this.id, required this.title, required this.description});
// //
// //   factory Task.fromJson(Map<String, dynamic> json) => Task(
// //     id: json['id'],
// //     title: json['title'],
// //     description: json['description'],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     'title': title,
// //     'description': description,
// //   };
// // }
// //
// // class ApiService {
// //   Future<List<Task>> fetchTasks() async {
// //     final res = await http.get(Uri.parse(baseUrl));
// //     final List<dynamic> data = json.decode(res.body);
// //     return data.map((json) => Task.fromJson(json)).toList();
// //   }
// //
// //   Future<Task> createTask(String title, String desc) async {
// //     final res = await http.post(
// //       Uri.parse(baseUrl),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({'title': title, 'description': desc}),
// //     );
// //     return Task.fromJson(json.decode(res.body));
// //   }
// //
// //   Future<void> updateTask(int id, String title, String desc) async {
// //     await http.put(
// //       Uri.parse('$baseUrl$id/'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({'title': title, 'description': desc}),
// //     );
// //   }
// //
// //   Future<void> deleteTask(int id) async {
// //     await http.delete(Uri.parse('$baseUrl$id/'));
// //   }
// // }
// //
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // // Base URL configuration - same as in main.dart
// // const String baseUrl = 'http://172.22.144.1:8000/api/tasks/';
// //
// // // Task model with essential properties (keeping the original from main.dart)
// // class Task {
// //   final int id;
// //   final String title;
// //   final String description;
// //   final bool isCompleted;
// //   final DateTime? dueDate;
// //   final String? priority;
// //
// //   Task({
// //     required this.id,
// //     required this.title,
// //     required this.description,
// //     this.isCompleted = false,
// //     this.dueDate,
// //     this.priority,
// //   });
// //
// //   factory Task.fromJson(Map<String, dynamic> json) => Task(
// //     id: json['id'],
// //     title: json['title'],
// //     description: json['description'],
// //     isCompleted: json['is_completed'] ?? false,
// //     dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
// //     priority: json['priority'],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     'title': title,
// //     'description': description,
// //     'is_completed': isCompleted,
// //     'due_date': dueDate?.toIso8601String(),
// //     'priority': priority,
// //   };
// //
// //   Task copyWith({
// //     int? id,
// //     String? title,
// //     String? description,
// //     bool? isCompleted,
// //     DateTime? dueDate,
// //     String? priority,
// //   }) {
// //     return Task(
// //       id: id ?? this.id,
// //       title: title ?? this.title,
// //       description: description ?? this.description,
// //       isCompleted: isCompleted ?? this.isCompleted,
// //       dueDate: dueDate ?? this.dueDate,
// //       priority: priority ?? this.priority,
// //     );
// //   }
// // }
// //
// // // API service with CRUD operations
// // class ApiService {
// //   static final ApiService _instance = ApiService._internal();
// //   factory ApiService() => _instance;
// //   ApiService._internal();
// //
// //   Future<List<Task>> fetchTasks() async {
// //     try {
// //       final res = await http.get(Uri.parse(baseUrl)).timeout(
// //         const Duration(seconds: 10),
// //       );
// //
// //       if (res.statusCode == 200) {
// //         final List<dynamic> data = json.decode(res.body);
// //         final tasks = data.map((json) => Task.fromJson(json)).toList();
// //         await _cacheTasks(tasks);
// //         return tasks;
// //       } else {
// //         throw Exception('Failed to load tasks: ${res.statusCode}');
// //       }
// //     } catch (e) {
// //       // Handle offline mode by returning cached tasks
// //       return _getCachedTasks();
// //     }
// //   }
// //
// //   Future<Task> createTask(Task task) async {
// //     try {
// //       final res = await http.post(
// //         Uri.parse(baseUrl),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode(task.toJson()),
// //       );
// //
// //       if (res.statusCode == 201) {
// //         return Task.fromJson(json.decode(res.body));
// //       } else {
// //         throw Exception('Failed to create task: ${res.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('Network error: $e');
// //     }
// //   }
// //
// //   Future<Task> updateTask(Task task) async {
// //     try {
// //       final res = await http.put(
// //         Uri.parse('$baseUrl${task.id}/'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode(task.toJson()),
// //       );
// //
// //       if (res.statusCode == 200) {
// //         return Task.fromJson(json.decode(res.body));
// //       } else {
// //         throw Exception('Failed to update task: ${res.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('Network error: $e');
// //     }
// //   }
// //
// //   Future<void> deleteTask(int id) async {
// //     try {
// //       final res = await http.delete(Uri.parse('$baseUrl$id/'));
// //       if (res.statusCode != 204) {
// //         throw Exception('Failed to delete task: ${res.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('Network error: $e');
// //     }
// //   }
// //
// //   // Toggle task completion status
// //   Future<Task> toggleTaskCompletion(Task task) async {
// //     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
// //     return updateTask(updatedTask);
// //   }
// //
// //   // Cache tasks locally for offline access
// //   Future<void> _cacheTasks(List<Task> tasks) async {
// //     final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('cached_tasks', tasksJson);
// //   }
// //
// //   // Get cached tasks when offline
// //   Future<List<Task>> _getCachedTasks() async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final String? tasksJson = prefs.getString('cached_tasks');
// //     if (tasksJson != null) {
// //       final List<dynamic> data = json.decode(tasksJson);
// //       return data.map((json) => Task.fromJson(json)).toList();
// //     }
// //     return [];
// //   }
// // }
//
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // Base URL
// const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';
//
// // Task model
// class Task {
//   final int? id; // Made nullable for new tasks
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final DateTime? dueDate;
//   final String? priority;
//
//   Task({
//     this.id,
//     required this.title,
//     required this.description,
//     this.isCompleted = false,
//     this.dueDate,
//     this.priority,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) => Task(
//     id: json['id'],
//     title: json['title'],
//     description: json['description'],
//     isCompleted: json['is_completed'] ?? false,
//     dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
//     priority: json['priority'],
//   );
//
//   Map<String, dynamic> toJson() {
//     final map = {
//       'title': title,
//       'description': description,
//       'is_completed': isCompleted,
//       'due_date': dueDate?.toIso8601String().split('T')[0],
//       'priority': priority,
//     };
//
//     // Remove any null values before sending
//     map.removeWhere((key, value) => value == null);
//     return map;
//   }
//
//   Task copyWith({
//     int? id,
//     String? title,
//     String? description,
//     bool? isCompleted,
//     DateTime? dueDate,
//     String? priority,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       isCompleted: isCompleted ?? this.isCompleted,
//       dueDate: dueDate ?? this.dueDate,
//       priority: priority ?? this.priority,
//     );
//   }
// }
//
// // API Service
// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();
//
//   Future<List<Task>> fetchTasks() async {
//     try {
//       final res = await http.get(Uri.parse(baseUrl)).timeout(
//         const Duration(seconds: 10),
//       );
//
//       if (res.statusCode == 200) {
//         final List<dynamic> data = json.decode(res.body);
//         final tasks = data.map((json) => Task.fromJson(json)).toList();
//         await _cacheTasks(tasks);
//         return tasks;
//       } else {
//         throw Exception('Failed to load tasks: ${res.statusCode}');
//       }
//     } catch (e) {
//       return _getCachedTasks(); // Offline fallback
//     }
//   }
//
//   Future<Task> createTask(Task task) async {
//     try {
//       final jsonBody = json.encode(task.toJson());
//       print('Sending JSON: $jsonBody'); // Debug log
//
//       final res = await http.post(
//         Uri.parse(baseUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonBody,
//       );
//
//       if (res.statusCode == 201) {
//         return Task.fromJson(json.decode(res.body));
//       } else {
//         throw Exception('Failed to create task: ${res.statusCode} - ${res.body}');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
//
//   Future<Task> updateTask(Task task) async {
//     try {
//       final res = await http.put(
//         Uri.parse('$baseUrl${task.id}/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(task.toJson()),
//       );
//
//       if (res.statusCode == 200) {
//         return Task.fromJson(json.decode(res.body));
//       } else {
//         throw Exception('Failed to update task: ${res.statusCode} - ${res.body}');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
//
//   Future<void> deleteTask(int id) async {
//     try {
//       final res = await http.delete(Uri.parse('$baseUrl$id/'));
//       if (res.statusCode != 204) {
//         throw Exception('Failed to delete task: ${res.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
//
//   Future<Task> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return updateTask(updatedTask);
//   }
//
//   Future<void> _cacheTasks(List<Task> tasks) async {
//     final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('cached_tasks', tasksJson);
//   }
//
//   Future<List<Task>> _getCachedTasks() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? tasksJson = prefs.getString('cached_tasks');
//     if (tasksJson != null) {
//       final List<dynamic> data = json.decode(tasksJson);
//       return data.map((json) => Task.fromJson(json)).toList();
//     }
//     return [];
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Base URL
const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';

// Task model
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? priority;
  final String? imageUrl;
  final String? fileUrl;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority,
    this.imageUrl,
    this.fileUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['is_completed'] ?? false,
    dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    priority: json['priority'],
    imageUrl: json['image_url'],
    fileUrl: json['file_url'],
  );

  Map<String, String> toJson() {
    final map = {
      'title': title,
      'description': description,
      'is_completed': isCompleted.toString(),
      if (dueDate != null) 'due_date': dueDate!.toIso8601String().split('T')[0],
      if (priority != null) 'priority': priority!,
      'imageUrl':imageUrl.toString(),
      'fileUrl':fileUrl.toString()
    };
    return map;
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? priority,
    String? imageUrl,
    String? fileUrl,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}

// API Service
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Task>> fetchTasks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        final tasks = data.map((json) => Task.fromJson(json)).toList();
        await _cacheTasks(tasks);
        return tasks;
      } else {
        throw Exception('Failed to load tasks: ${res.statusCode}');
      }
    } catch (e) {
      return _getCachedTasks(); // Offline fallback
    }
  }

  Future<Task> createTaskWithFiles(Task task, {File? image, File? file}) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    // Add fields
    request.fields.addAll(task.toJson());

    // Add image file if present
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
    }

    // Add attachment if present
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Task> updateTaskWithFiles(Task task, {File? image, File? file}) async {
    final uri = Uri.parse('$baseUrl${task.id}/');
    final request = http.MultipartRequest('PUT', uri);

    request.fields.addAll(task.toJson());

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
    }

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl$id/'));
      if (res.statusCode != 204) {
        throw Exception('Failed to delete task: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Task> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return updateTaskWithFiles(updatedTask); // If no file changes, just pass null
  }

  Future<void> _cacheTasks(List<Task> tasks) async {
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_tasks', tasksJson);
  }

  Future<List<Task>> _getCachedTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('cached_tasks');
    if (tasksJson != null) {
      final List<dynamic> data = json.decode(tasksJson);
      return data.map((json) => Task.fromJson(json)).toList();
    }
    return [];
  }
}

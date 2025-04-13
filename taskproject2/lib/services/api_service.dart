// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/task_model.dart';
// import '../utils/constants.dart';
//
// class ApiService {
//   final String token;
//
//   ApiService(this.token);
//
//   Future<List<Task>> fetchTasks() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/tasks/'),
//       headers: {
//         'Authorization': 'Token $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Task.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }
// }


// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // Base URLs
// const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';
// const String loginUrl = 'http://172.16.2.130:8000/api/login/';
// const String registerUrl = 'http://172.16.2.130:8000/api/register/';
// const String logoutUrl = 'http://172.16.2.130:8000/api/logout/';
//
// // Task model
// class Task {
//   final int? id;
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final DateTime? dueDate;
//   final String? priority;
//   final String? imageUrl;
//   final String? fileUrl;
//
//   Task({
//     this.id,
//     required this.title,
//     required this.description,
//     this.isCompleted = false,
//     this.dueDate,
//     this.priority,
//     this.imageUrl,
//     this.fileUrl,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) => Task(
//     id: json['id'],
//     title: json['title'],
//     description: json['description'],
//     isCompleted: json['is_completed'] ?? false,
//     dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
//     priority: json['priority'],
//     imageUrl: json['image_url'],
//     fileUrl: json['file_url'],
//   );
//
//   Map<String, String> toJson() {
//     final map = {
//       'title': title,
//       'description': description,
//       'is_completed': isCompleted.toString(),
//       if (dueDate != null) 'due_date': dueDate!.toIso8601String().split('T')[0],
//       if (priority != null) 'priority': priority!,
//       'imageUrl': imageUrl.toString(),
//       'fileUrl': fileUrl.toString(),
//     };
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
//     String? imageUrl,
//     String? fileUrl,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       isCompleted: isCompleted ?? this.isCompleted,
//       dueDate: dueDate ?? this.dueDate,
//       priority: priority ?? this.priority,
//       imageUrl: imageUrl ?? this.imageUrl,
//       fileUrl: fileUrl ?? this.fileUrl,
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
//   String? _token;
//
//   static Future<void> login(String username, String password) async {
//     final response = await http.post(Uri.parse(loginUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       _token = data['token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//     } else {
//       throw Exception('Login failed: ${response.body}');
//     }
//   }
//
//   Future<void> register(String username, String password) async {
//     final response = await http.post(Uri.parse(registerUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode != 201) {
//       throw Exception('Registration failed: ${response.body}');
//     }
//   }
//
//   Future<void> logout() async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse(logoutUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('token');
//       _token = null;
//     } else {
//       throw Exception('Logout failed');
//     }
//   }
//
//   Future<List<Task>> fetchTasks() async {
//     final token = await _getToken();
//     final res = await http.get(
//       Uri.parse(baseUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (res.statusCode == 200) {
//       final List<dynamic> data = json.decode(res.body);
//       final tasks = data.map((json) => Task.fromJson(json)).toList();
//       await _cacheTasks(tasks);
//       return tasks;
//     } else {
//       return _getCachedTasks();
//     }
//   }
//
//   Future<Task> createTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse(baseUrl);
//     final request = http.MultipartRequest('POST', uri);
//     request.headers['Authorization'] = 'Token $token';
//     request.fields.addAll(task.toJson());
//
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
//     }
//     if (file != null) {
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 201) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to create task: ${response.body}');
//     }
//   }
//
//   Future<Task> updateTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse('$baseUrl${task.id}/');
//     final request = http.MultipartRequest('PUT', uri);
//     request.headers['Authorization'] = 'Token $token';
//     request.fields.addAll(task.toJson());
//
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
//     }
//     if (file != null) {
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update task: ${response.body}');
//     }
//   }
//
//   Future<void> deleteTask(int id) async {
//     final token = await _getToken();
//     final res = await http.delete(
//       Uri.parse('$baseUrl$id/'),
//       headers: {'Authorization': 'Token $token'},
//     );
//     if (res.statusCode != 204) {
//       throw Exception('Failed to delete task: ${res.body}');
//     }
//   }
//
//   Future<Task> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return updateTaskWithFiles(updatedTask);
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
//
//   Future<String?> _getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     return _token;
//   }
// }


// CONTINUED: ApiService class

//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/task_model.dart';
//
// // Base URLs
// const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';
// const String loginUrl = 'http://172.16.2.130:8000/api/login/';
// const String registerUrl = 'http://172.16.2.130:8000/api/register/';
// const String logoutUrl = 'http://172.16.2.130:8000/api/logout/';
//
// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();
//
//   String? _token;
//
//   Future<void> login(String username, String password) async {
//     final response = await http.post(Uri.parse(loginUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       _token = data['token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//     } else {
//       throw Exception('Login failed: ${response.body}');
//     }
//   }
//
//   Future<void> register(String username, String password) async {
//     final response = await http.post(Uri.parse(registerUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode != 201) {
//       throw Exception('Registration failed: ${response.body}');
//     }
//   }
//
//   Future<void> logout() async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse(logoutUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('token');
//       _token = null;
//     } else {
//       throw Exception('Logout failed');
//     }
//   }
//   Future<List<Task>> fetchTasks() async {
//     try {
//       final token = await _getToken(); // Assuming this method fetches the token
//       final response = await http.get(
//         Uri.parse('$baseUrl'), // Ensure you append the endpoint to the base URL
//         headers: {'Authorization': 'Token $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body); // Parse response body as JSON
//         final tasks = data.map((json) => Task.fromJson(json)).toList(); // Convert JSON to Task objects
//         await _cacheTasks(tasks); // Cache the tasks if needed
//         return tasks; // Return the list of tasks
//       } else {
//         // If response isn't successful, attempt to return cached tasks.
//         return await _getCachedTasks();
//       }
//     } catch (error) {
//       // Handle error (e.g., network issues, invalid JSON, etc.)
//       print('Error fetching tasks: $error');
//       return await _getCachedTasks(); // Return cached tasks in case of error
//     }
//   }
//
//   Future<Task> createTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse(baseUrl);
//     final request = http.MultipartRequest('POST', uri);
//     request.headers['Authorization'] = 'Token $token';
//     request.fields.addAll(task.toJson());
//
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
//     }
//
//     if (file != null) {
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 201) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to create task: ${response.body}');
//     }
//   }
//
//   Future<Task> updateTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse('$baseUrl${task.id}/');
//     final request = http.MultipartRequest('PUT', uri);
//     request.headers['Authorization'] = 'Token $token';
//     request.fields.addAll(task.toJson());
//
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
//     }
//
//     if (file != null) {
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update task: ${response.body}');
//     }
//   }
//
//   Future<void> deleteTask(int id) async {
//     final token = await _getToken();
//     final response = await http.delete(
//       Uri.parse('$baseUrl$id/'),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete task: ${response.body}');
//     }
//   }
//
//   Future<Task> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return updateTaskWithFiles(updatedTask);
//   }
//
//   Future<void> _cacheTasks(List<Task> tasks) async {
//     final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('cached_tasks', tasksJson);
//   }
//
//   Future<List<Task>> _getCachedTasks() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? tasksJson = prefs.getString('cached_tasks');
//     if (tasksJson != null) {
//       final List<dynamic> data = json.decode(tasksJson);
//       return data.map((json) => Task.fromJson(json)).toList();
//     }
//     return [];
//   }
//
//   Future<String?> _getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     return _token;
//   }
// }
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/task_model.dart';
//
// // Base URLs
// const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';
// const String loginUrl = 'http://172.16.2.130:8000/api/login/';
// const String registerUrl = 'http://172.16.2.130:8000/api/register/';
// const String logoutUrl = 'http://172.16.2.130:8000/api/logout/';
//
// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();
//
//   String? _token;
//
//   Future<void> login(String username, String password) async {
//     final response = await http.post(Uri.parse(loginUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       _token = data['token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//     } else {
//       throw Exception('Login failed: ${response.body}');
//     }
//   }
//
//   Future<void> register(String username, String password) async {
//     final response = await http.post(Uri.parse(registerUrl), body: {
//       'username': username,
//       'password': password,
//     });
//
//     if (response.statusCode != 201) {
//       throw Exception('Registration failed: ${response.body}');
//     }
//   }
//
//   Future<void> logout() async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse(logoutUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('token');
//       _token = null;
//     } else {
//       throw Exception('Logout failed');
//     }
//   }
//
//   Future<List<Task>> fetchTasks() async {
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(baseUrl),
//         headers: {'Authorization': 'Token $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         final tasks = data.map((json) => Task.fromJson(json)).toList();
//         await _cacheTasks(tasks);
//         return tasks;
//       } else {
//         return await _getCachedTasks();
//       }
//     } catch (error) {
//       print('Error fetching tasks: $error');
//       return await _getCachedTasks();
//     }
//   }
//
//   Future<Task> createTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse(baseUrl);
//     final request = http.MultipartRequest('POST', uri);
//     request.headers['Authorization'] = 'Token $token';
//     request.fields.addAll(task.toJson());
//
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)));
//     }
//
//     if (file != null) {
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 201) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to create task: ${response.body}');
//     }
//   }
//   Future<Task> updateTaskPartialWithFiles(
//       Task task,
//       int taskId,
//       Map<String, dynamic> updates, {
//         File? image,
//         File? file,
//       }) async {
//     final token = await _getToken();
//     final uri = Uri.parse('$baseUrl${task.id}/');
//     final request = http.MultipartRequest('PATCH', uri);
//     request.headers['Authorization'] = 'Token $token';
//
//     // Add only non-null fields
//     updates.forEach((key, value) {
//       if (value != null) {
//         request.fields[key] = value.toString();
//       }
//     });
//
//     // Conditionally add image if present
//     if (image != null && image.existsSync()) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'image',
//         image.path,
//         filename: basename(image.path),
//       ));
//     }
//
//     // Conditionally add file if present
//     if (file != null && file.existsSync()) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'file',
//         file.path,
//         filename: basename(file.path),
//       ));
//     }
//
//     // Send the request
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       print('PATCH error: ${response.body}');
//       throw Exception('Failed to partially update task.');
//     }
//   }
//
//
//   Future<Task> updateTaskWithFiles(Task task, {File? image, File? file}) async {
//     final token = await _getToken();
//     final uri = Uri.parse('$baseUrl${task.id}/');
//     final request = http.MultipartRequest('PATCH', uri);
//     request.headers['Authorization'] = 'Token $token';
//
//     // Convert Task to map and add only non-null fields
//     final taskData = task.toJson();
//     taskData.forEach((key, value) {
//       if (value != null) {
//         request.fields[key] = value.toString();
//       }
//     });
//
//     // Only send new image if selected
//     if (image != null && image.existsSync()) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'image',
//         image.path,
//         filename: basename(image.path),
//       ));
//     }
//
//     // Only send new file if selected
//     if (file != null && file.existsSync()) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'file',
//         file.path,
//         filename: basename(file.path),
//       ));
//     }
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       return Task.fromJson(json.decode(response.body));
//     } else {
//       print('Update task failed: ${response.body}');
//       throw Exception('Failed to update task.');
//     }
//   }
//
//   Future<void> deleteTask(int id) async {
//     final token = await _getToken();
//     final response = await http.delete(
//       Uri.parse('$baseUrl$id/'),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete task: ${response.body}');
//     }
//   }
//
//   Future<Task> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return updateTaskWithFiles(updatedTask);
//   }
//
//   Future<void> _cacheTasks(List<Task> tasks) async {
//     final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('cached_tasks', tasksJson);
//   }
//
//   Future<List<Task>> _getCachedTasks() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? tasksJson = prefs.getString('cached_tasks');
//     if (tasksJson != null) {
//       final List<dynamic> data = json.decode(tasksJson);
//       return data.map((json) => Task.fromJson(json)).toList();
//     }
//     return [];
//   }
//
//
//   Future<String?> _getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     return _token;
//   }
// }
//

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

// Base URLs - Consider using environment variables for different environments
const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';
const String loginUrl = 'http://172.16.2.130:8000/api/login/';
const String registerUrl = 'http://172.16.2.130:8000/api/register/';
const String logoutUrl = 'http://172.16.2.130:8000/api/logout/';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  bool get isLoggedIn => _token != null;

  // Check if token exists on app start
  Future<bool> initToken() async {
    final token = await _getToken();
    return token != null;
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(Uri.parse(loginUrl), body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
      } else {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Login failed: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error during login: $e');
    }
  }


  Future<void> register(String username, String password) async {
    try {
      final response = await http.post(Uri.parse(registerUrl), body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode != 201) {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Registration failed: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error during registration: $e');
    }
  }

  Future<void> logout() async {
    final token = await _getToken();
    if (token == null) {
      // Already logged out
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {'Authorization': 'Token $token'},
      );

      // Clear token regardless of response
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;

      if (response.statusCode != 200) {
        print('Warning: Logout returned status ${response.statusCode}');
      }
    } catch (e) {
      // Still clear token even if logout fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;

      print('Error during logout: $e');
      // We don't throw here as we still want to log out locally
    }
  }

  Future<List<Task>> fetchTasks() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final tasks = data.map((json) => Task.fromJson(json)).toList();
        await _cacheTasks(tasks);
        return tasks;
      } else {
        print('Error fetching tasks: ${response.statusCode}');
        return await _getCachedTasks();
      }
    } catch (error) {
      print('Error fetching tasks: $error');
      return await _getCachedTasks();
    }
  }

  Future<Task> createTaskWithFiles(Task task, {File? image, File? file}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Token $token';

      // Add all task fields
      request.fields.addAll(task.toJson());

      // Conditionally add image and file
      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: basename(image.path)
        ));
      }

      if (file != null && file.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path)
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Failed to create task: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error creating task: $e');
    }
  }

  Future<Task> updateTaskWithFiles(Task task, {File? image, File? file}) async {
    try {
      if (task.id == null) {
        throw Exception("Task ID is required for update");
      }

      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$baseUrl${task.id}/');
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Token $token';

      // Add all task fields
      request.fields.addAll(task.toJson());

      // Conditionally add image and file
      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: basename(image.path)
        ));
      }

      if (file != null && file.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path)
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Failed to update task: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error updating task: $e');
    }
  }

  Future<Task> updateTaskPartial(int taskId, Map<String, dynamic> updates, {File? image, File? file}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$baseUrl$taskId/');
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Token $token';

      // Add only the fields that need to be updated
      updates.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Conditionally add image and file
      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: basename(image.path)
        ));
      }

      if (file != null && file.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path)
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Failed to update task: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error updating task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$id/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode != 204) {
        final errorMsg = _parseErrorResponse(response);
        throw Exception('Failed to delete task: $errorMsg');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error deleting task: $e');
    }
  }

  Future<Task> toggleTaskCompletion(Task task) async {
    if (task.id == null) {
      throw Exception("Task ID is required for update");
    }

    // Create map with just the is_completed field
    final updates = {'is_completed': (!task.isCompleted).toString()};

    // Use partial update to only send the field we're changing
    return updateTaskPartial(task.id!, updates);
  }

  Future<void> _cacheTasks(List<Task> tasks) async {
    try {
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_tasks', tasksJson);
    } catch (e) {
      print('Error caching tasks: $e');
    }
  }


  Future<List<Task>> _getCachedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('cached_tasks');
      if (tasksJson != null) {
        final List<dynamic> data = json.decode(tasksJson);
        return data.map((json) => Task.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting cached tasks: $e');
    }
    return [];
  }

  Future<String?> _getToken() async {
    if (_token != null) return _token;

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      return _token;
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }


  // Helper to parse error responses
  String _parseErrorResponse(http.Response response) {
    try {
      final data = json.decode(response.body);

      // Handle different error formats
      if (data is Map<String, dynamic>) {
        // Some APIs return errors as {"detail": "error message"}
        if (data.containsKey('detail')) {
          return data['detail'];
        }

        // Some return as {"field": ["error message"]}
        final errors = <String>[];
        data.forEach((key, value) {
          if (value is List) {
            errors.add('$key: ${value.join(", ")}');
          } else {
            errors.add('$key: $value');
          }
        });

        if (errors.isNotEmpty) {
          return errors.join(", ");
        }
      }

      // Fallback
      return 'Status code: ${response.statusCode}';
    } catch (e) {
      return 'Status code: ${response.statusCode}';
    }
  }
}
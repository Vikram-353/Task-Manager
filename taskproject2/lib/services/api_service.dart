
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';


// Base URLs - Consider using environment variables for different environments
const String taskUrl = '${baseUrl}/api/tasks/';
const String loginUrl = '${baseUrl}/api/login/';
const String registerUrl = '${baseUrl}/api/register/';
const String logoutUrl = '${baseUrl}/api/logout/';
const String fcmSendUrl = '${baseUrl}/api/send-notification/';


class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  bool get isLoggedIn => _token != null;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  // Check if token exists on app start
  Future<bool> initToken() async {
    final token = await _getToken();

    return token != null;
  }
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        await checkOverdueTasks();
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
        Uri.parse(taskUrl),
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

      final uri = Uri.parse(taskUrl);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Token $token';

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
      await checkOverdueTasks();

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

      final uri = Uri.parse('$taskUrl${task.id}/');
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

  // Future<Task> updateTaskPartial(int taskId, Map<String, dynamic> updates, {File? image, File? file}) async {
  //   try {
  //     final token = await _getToken();
  //     if (token == null) {
  //       throw Exception('Not authenticated');
  //     }
  //
  //     final uri = Uri.parse('$taskUrl$taskId/');
  //     final request = http.MultipartRequest('PATCH', uri);
  //     request.headers['Authorization'] = 'Token $token';
  //
  //     // Add only the fields that need to be updated
  //     updates.forEach((key, value) {
  //       if (value != null) {
  //         request.fields[key] = value.toString();
  //       }
  //     });
  //
  //     // Conditionally add image and file
  //     if (image != null && image.existsSync()) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'image',
  //           image.path,
  //           filename: basename(image.path)
  //       ));
  //     }
  //
  //     if (file != null && file.existsSync()) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'file',
  //           file.path,
  //           filename: basename(file.path)
  //       ));
  //     }
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200) {
  //       return Task.fromJson(json.decode(response.body));
  //     } else {
  //       final errorMsg = _parseErrorResponse(response);
  //       throw Exception('Failed to update task: $errorMsg');
  //     }
  //   } catch (e) {
  //     if (e is Exception) rethrow;
  //     throw Exception('Network error updating task: $e');
  //   }
  // }

  Future<Task> updateTaskPartial(int taskId, Map<String, dynamic> updates, {File? image, File? file}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$taskUrl$taskId/');
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Token $token';

      // Add only the fields that need to be updated (non-null fields)
      updates.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Conditionally add image and file if provided and changed
      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: basename(image.path),
        ));
      }

      if (file != null && file.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: basename(file.path),
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
  void startPeriodicNotifications() {
    const duration = Duration(seconds: 1);

    // Start periodic checks for overdue tasks
    Timer.periodic(duration, (timer) {
      checkOverdueTasks();
    });
  }

  Future<void> checkOverdueTasks() async {
    try {
      final tasks = await fetchTasks();
      final now = DateTime.now();

      for (final task in tasks) {
        if (task.dueDate != null && task.dueDate!.isBefore(now) && !task.isCompleted) {
          _sendOverdueNotification(task);
        }
      }
    } catch (error) {
      print('Error checking overdue tasks: $error');
    }
  }

  Future<void> _sendOverdueNotification(Task task) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_overdue_channel',
      'Task Overdue Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Task Overdue: ${task.title}',
      'The task "${task.title}" is overdue. Please complete it.',
      notificationDetails,
    );
  }


  Future<void> deleteTask(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$taskUrl$id/'),
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

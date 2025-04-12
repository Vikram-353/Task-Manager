import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Base URL configuration
const String baseUrl = 'http://172.16.2.130:8000/api/tasks/';

// Task model with essential properties
class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority,
  });

  // factory Task.fromJson(Map<String, dynamic> json) => Task(
  //   id: json['id'],
  //   title: json['title'],
  //   description: json['description'],
  //   isCompleted: json['is_completed'] ?? false,
  //   dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
  //   priority: json['priority'],
  // );
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['is_completed'] ?? false,
    // Parse the date string coming from Django (YYYY-MM-DD format)
    dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    priority: json['priority'],
  );

  // Map<String, dynamic> toJson() => {
  //   'title': title,
  //   'description': description,
  //   'is_completed': isCompleted,
  //   'due_date': dueDate?.toIso8601String(),
  //   'priority': priority,
  // };
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'is_completed': isCompleted,
    // Format the date as 'YYYY-MM-DD' when sending it back to Django
    'due_date': dueDate != null ? dueDate!.toIso8601String().split('T').first : null,
    'priority': priority,
  };
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}

// API service with basic CRUD operations
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Task>> fetchTasks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        final tasks = data.map((json) => Task.fromJson(json)).toList();
        await _cacheTasks(tasks);
        return tasks;
      } else {
        throw Exception('Failed to load tasks: ${res.statusCode}');
      }
    } catch (e) {
      // Handle offline mode
      return _getCachedTasks();
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (res.statusCode == 201) {
        return Task.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to create task: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl${task.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (res.statusCode == 200) {
        return Task.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to update task: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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

  // Toggle task completion status
  Future<Task> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return updateTask(updatedTask);
  }

  // Cache tasks locally
  Future<void> _cacheTasks(List<Task> tasks) async {
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_tasks', tasksJson);
  }

  // Get cached tasks
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

// Theme configuration
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.deepPurple,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskApp());
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('is_dark_mode', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TaskListScreen(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const TaskListScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _filterMode = 'all'; // all, completed, active
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await _apiService.fetchTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load tasks: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _fetchTasks,
        ),
      ),
    );
  }

  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      // Filter by status
      bool statusMatch = false;
      if (_filterMode == 'all') {
        statusMatch = true;
      } else if (_filterMode == 'completed') {
        statusMatch = task.isCompleted;
      } else {
        statusMatch = !task.isCompleted;
      }

      // Filter by search
      bool searchMatch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return statusMatch && searchMatch;
    }).toList();
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = await _apiService.toggleTaskCompletion(task);
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
      });
    } catch (e) {
      _showErrorSnackBar('Failed to update task: $e');
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _apiService.deleteTask(task.id);
      setState(() {
        _tasks.removeWhere((t) => t.id == task.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted successfully'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                try {
                  final createdTask = await _apiService.createTask(task);
                  setState(() {
                    _tasks.add(createdTask);
                  });
                } catch (e) {
                  _showErrorSnackBar('Failed to restore task: $e');
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to delete task: $e');
    }
  }

  void _openTaskEditor({Task? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditorScreen(task: task),
      ),
    ).then((newOrUpdatedTask) {
      if (newOrUpdatedTask != null) {
        _fetchTasks(); // Refresh all tasks
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => widget.toggleTheme(),
            tooltip: widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterOptions(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt, size: 70, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks found',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first task by tapping the + button',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _fetchTasks,
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return _buildTaskItem(task);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', _filterMode == 'all', () {
              setState(() {
                _filterMode = 'all';
              });
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Active', _filterMode == 'active', () {
              setState(() {
                _filterMode = 'active';
              });
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Completed', _filterMode == 'completed', () {
              setState(() {
                _filterMode = 'completed';
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final theme = Theme.of(context);

    // Format the due date if it exists
    final formattedDueDate = task.dueDate != null
        ? DateFormat('MMM d, yyyy').format(task.dueDate!)
        : null;

    // Calculate if task is overdue
    final isOverdue = task.dueDate != null &&
        !task.isCompleted &&
        task.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: task.isCompleted ? theme.colorScheme.primary : null,
          ),
          onPressed: () => _toggleTaskCompletion(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            if (formattedDueDate != null)
              Text(
                'Due: $formattedDueDate',
                style: TextStyle(
                  color: isOverdue ? Colors.red : null,
                  fontWeight: isOverdue ? FontWeight.bold : null,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.priority != null)
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.priority == 'high'
                      ? Colors.red
                      : task.priority == 'medium'
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _openTaskEditor(task: task);
                } else if (value == 'delete') {
                  _deleteTask(task);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _openTaskEditor(task: task),
      ),
    );
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Task Editor Screen
class TaskEditorScreen extends StatefulWidget {
  final Task? task;

  const TaskEditorScreen({
    super.key,
    this.task,
  });

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  String? _priority;
  bool _isCompleted = false;
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeFormValues();
  }

  void _initializeFormValues() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final Task taskData = Task(
          id: widget.task?.id ?? 0,
          title: _titleController.text,
          description: _descriptionController.text,
          isCompleted: _isCompleted,
          dueDate: _dueDate,
          priority: _priority,
        );

        final Task savedTask = widget.task == null
            ? await _apiService.createTask(taskData)
            : await _apiService.updateTask(taskData);

        if (mounted) {
          Navigator.pop(context, savedTask);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save task: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveTask,
              tooltip: 'Save Task',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description (optional)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Due Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              subtitle: Text(
                _dueDate == null
                    ? 'No due date set'
                    : DateFormat('MMM d, yyyy').format(_dueDate!),
              ),
              trailing: _dueDate != null
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _dueDate = null;
                  });
                },
              )
                  : null,
              onTap: _selectDueDate,
            ),
            const Divider(),

            // Priority selector
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Priority'),
              trailing: DropdownButton<String>(
                value: _priority,
                hint: const Text('Set priority'),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue;
                  });
                },
                items: <String>['low', 'medium', 'high']
                    .map<DropdownMenuItem<String>>((String value) {
                  Color color;
                  switch (value) {
                    case 'high':
                      color = Colors.red;
                      break;
                    case 'medium':
                      color = Colors.orange;
                      break;
                    default:
                      color = Colors.green;
                  }

                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(value.capitalize()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Completion status
            if (isEditing)
              SwitchListTile(
                title: const Text('Mark as completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
                secondary: Icon(
                  _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: _isCompleted ? theme.colorScheme.primary : null,
                ),
              ),
            const SizedBox(height: 24),

            // Save button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveTask,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Update Task' : 'Create Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
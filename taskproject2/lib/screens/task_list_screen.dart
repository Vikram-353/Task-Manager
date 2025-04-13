// import 'package:flutter/material.dart';
// import '../models/task_model.dart';
// import '../services/api_service.dart';
// import '../widgets/task_card.dart';
//
// class TaskListScreen extends StatelessWidget {
//   final String token;
//
//   const TaskListScreen({required this.token});
//
//   @override
//   Widget build(BuildContext context) {
//     final apiService = ApiService(token);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Tasks')),
//       body: FutureBuilder<List<Task>>(
//         future: apiService.fetchTasks(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final tasks = snapshot.data!;
//             return ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (_, i) => TaskCard(task: tasks[i]),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading tasks'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart';
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> tasks;
//
//   @override
//   void initState() {
//     super.initState();
//     tasks = ApiService().fetchTasks();
//   }
//
//   void logout() async {
//     await ApiService.logout();
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Tasks'), actions: [
//         IconButton(icon: Icon(Icons.logout), onPressed: logout),
//       ]),
//       body: FutureBuilder<List<Task>>(
//         future: tasks,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData) return Center(child: Text('No tasks available.'));
//           final data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final task = data[index];
//               return ListTile(
//                 title: Text(task.title),
//                 subtitle: Text(task.description),
//                 trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.circle),
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task))),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart' ;
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> tasks;
//
//   @override
//   void initState() {
//     super.initState();
//     tasks = ApiService().fetchTasks();  // No need to cast here
//   }
//
//   void logout() async {
//     final apiService = ApiService();  // Create an instance of ApiService
//     await apiService.logout();  // Use instance method to logout
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Tasks'), actions: [
//         IconButton(icon: Icon(Icons.logout), onPressed: logout),
//       ]),
//       body: FutureBuilder<List<Task>>(
//         future: tasks,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData) return Center(child: Text('No tasks available.'));
//           final data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final task = data[index];
//               return ListTile(
//                 title: Text(task.title),
//                 subtitle: Text(task.description),
//                 trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.circle),
//
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TaskDetailScreen(task: task), // fixed here
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart';
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> tasks;
//
//   @override
//   void initState() {
//     super.initState();
//     tasks = ApiService().fetchTasks();  // Fetch tasks from the API
//   }
//
//   void logout() async {
//     final apiService = ApiService();  // Create an instance of ApiService
//     await apiService.logout();  // Logout method
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => LoginScreen()),
//     );
//   }
//
//   // Function to handle edit action
//   void _editTask(Task task) {
//     // Navigate to edit screen or open an edit dialog
//     // For example: showDialog or navigate to another screen
//     print("Edit Task: ${task.title}");
//   }
//
//   // Function to handle delete action
//   void _deleteTask(Task task) {
//     // Call delete API or remove task from the list
//     setState(() {
//       tasks = ApiService().fetchTasks();  // Refresh task list after deletion
//     });
//     print("Delete Task: ${task.title}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks'),
//         actions: [
//           IconButton(icon: Icon(Icons.logout), onPressed: logout),
//         ],
//       ),
//       body: FutureBuilder<List<Task>>(
//         future: tasks,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData) return Center(child: Text('No tasks available.'));
//           final data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final task = data[index];
//               return ListTile(
//                 title: Text(task.title),
//                 subtitle: Text(task.description),
//                 trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.circle),
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TaskDetailScreen(
//                       task: task,
//                       onEdit: _editTask,
//                       onDelete: _deleteTask,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart';
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
// import 'task_form_screen.dart'; // We'll create this for add/edit functionality
// import 'dart:io'; // For File type
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> tasks;
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshTasks(); // Fetch tasks from the API
//   }
//
//   // Refresh tasks list
//   void _refreshTasks() {
//     setState(() {
//       tasks = apiService.fetchTasks();
//     });
//   }
//
//   void logout() async {
//     try {
//       await apiService.logout();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed: ${e.toString()}')),
//       );
//     }
//   }
//
//   // Add a new task
//   void _addTask() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           onSave: (Task newTask, {File? image, File? file}) async {
//             try {
//               await apiService.createTaskWithFiles(newTask, image: image, file: file);
//               _refreshTasks(); // Refresh the list after adding
//               return true;
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to add task: ${e.toString()}')),
//               );
//               return false;
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   // Edit an existing task
//   void _editTask(Task task) async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           task: task, // Pass existing task for editing
//           onSave: (Task updatedTask, {File? image, File? file}) async {
//             try {
//               await apiService.updateTaskWithFiles(updatedTask, image: image, file: file);
//               _refreshTasks(); // Refresh the list after updating
//               return true;
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//               );
//               return false;
//             }
//           },
//         ),
//       ),
//     );
//
//     // If result is true, the task was updated successfully in TaskFormScreen
//     if (result == true) {
//       _refreshTasks();
//     }
//   }
//
//   // Delete a task
//   void _deleteTask(Task task) async {
//     try {
//       await apiService.deleteTask(task.id!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Task deleted successfully')),
//       );
//       _refreshTasks(); // Refresh the list after deletion
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete task: ${e.toString()}')),
//       );
//     }
//   }
//
//   // Toggle task completion status
//   void _toggleTaskCompletion(Task task) async {
//     try {
//       await apiService.toggleTaskCompletion(task);
//       _refreshTasks(); // Refresh the list after toggling
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks'),
//         actions: [
//           IconButton(icon: Icon(Icons.logout), onPressed: logout),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Fixed: Return void instead of Future<List<Task>>
//           _refreshTasks();
//           // Wait for the tasks to be fetched but don't return them
//           await tasks;
//         },
//         child: FutureBuilder<List<Task>>(
//           future: tasks,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Center(child: CircularProgressIndicator());
//
//             if (snapshot.hasError)
//               return Center(child: Text('Error: ${snapshot.error}'));
//
//             if (!snapshot.hasData || snapshot.data!.isEmpty)
//               return Center(child: Text('No tasks available.'));
//
//             final data = snapshot.data!;
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final task = data[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: ListTile(
//                     title: Text(
//                       task.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         decoration: task.isCompleted ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     subtitle: Text(
//                       task.description,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     leading: task.imageUrl != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         task.imageUrl!,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             Icon(Icons.image_not_supported),
//                       ),
//                     )
//                         : null,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Toggle completion status
//                         IconButton(
//                           icon: Icon(
//                             task.isCompleted
//                                 ? Icons.check_circle
//                                 : Icons.circle_outlined,
//                             color: task.isCompleted ? Colors.green : Colors.grey,
//                           ),
//                           onPressed: () => _toggleTaskCompletion(task),
//                         ),
//                         // Menu for additional options
//                         PopupMenuButton<String>(
//                           onSelected: (value) {
//                             if (value == 'edit') {
//                               _editTask(task);
//                             } else if (value == 'delete') {
//                               _deleteTask(task);
//                             }
//                           },
//                           itemBuilder: (context) => [
//                             PopupMenuItem(
//                               value: 'edit',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.edit, size: 18),
//                                   SizedBox(width: 8),
//                                   Text('Edit'),
//                                 ],
//                               ),
//                             ),
//                             PopupMenuItem(
//                               value: 'delete',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.delete, size: 18, color: Colors.red),
//                                   SizedBox(width: 8),
//                                   Text('Delete', style: TextStyle(color: Colors.red)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TaskDetailScreen(
//                           task: task,
//                           onEdit: _editTask,
//                           onDelete: _deleteTask,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTask,
//         child: Icon(Icons.add),
//         tooltip: 'Add Task',
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart';
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
// import 'task_form_screen.dart'; // For add/edit functionality
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> tasks;
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshTasks(); // Fetch tasks from the API
//   }
//
//   // Refresh tasks list
//   void _refreshTasks() {
//     setState(() {
//       tasks = apiService.fetchTasks();
//     });
//   }
//
//   void logout() async {
//     try {
//       await apiService.logout();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed: ${e.toString()}')),
//       );
//     }
//   }
//
//   // Add a new task
//   void _addTask() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           onSave: (Task newTask, {File? image, File? file}) async {
//             try {
//               await apiService.createTaskWithFiles(newTask, image: image, file: file);
//               _refreshTasks(); // Refresh the list after adding
//               return true;
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to add task: ${e.toString()}')),
//               );
//               return false;
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   // Edit an existing task
//   void _editTask(Task task) async {
//     // Navigate directly to TaskFormScreen with the task data
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           task: task, // Pass existing task for editing
//           onSave: (Task updatedTask, {File? image, File? file}) async {
//             try {
//               await apiService.updateTaskWithFiles(updatedTask, image: image, file: file);
//               return true; // Return success
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//               );
//               return false; // Return failure
//             }
//           },
//         ),
//       ),
//     );
//
//     // If result is true, the task was updated successfully in TaskFormScreen
//     if (result == true) {
//       _refreshTasks(); // Refresh task list to show updated data
//     }
//   }
//
//   // Delete a task
//   void _deleteTask(Task task) async {
//     try {
//       if (task.id == null) {
//         throw Exception("Task ID is null");
//       }
//
//       await apiService.deleteTask(task.id!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Task deleted successfully')),
//       );
//       _refreshTasks(); // Refresh the list after deletion
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete task: ${e.toString()}')),
//       );
//     }
//   }
//
//   // Toggle task completion status
//   void _toggleTaskCompletion(Task task) async {
//     try {
//       await apiService.toggleTaskCompletion(task);
//       _refreshTasks(); // Refresh the list after toggling
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks'),
//         actions: [
//           IconButton(icon: Icon(Icons.logout), onPressed: logout),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           _refreshTasks();
//           // Wait for the tasks to be fetched
//           await tasks;
//         },
//         child: FutureBuilder<List<Task>>(
//           future: tasks,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Center(child: CircularProgressIndicator());
//
//             if (snapshot.hasError)
//               return Center(child: Text('Error: ${snapshot.error}'));
//
//             if (!snapshot.hasData || snapshot.data!.isEmpty)
//               return Center(child: Text('No tasks available.'));
//
//             final data = snapshot.data!;
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final task = data[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: ListTile(
//                     title: Text(
//                       task.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         decoration: task.isCompleted ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     subtitle: Text(
//                       task.description,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     leading: task.imageUrl != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         task.imageUrl!,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             Icon(Icons.image_not_supported),
//                       ),
//                     )
//                         : null,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Toggle completion status
//                         IconButton(
//                           icon: Icon(
//                             task.isCompleted
//                                 ? Icons.check_circle
//                                 : Icons.circle_outlined,
//                             color: task.isCompleted ? Colors.green : Colors.grey,
//                           ),
//                           onPressed: () => _toggleTaskCompletion(task),
//                         ),
//                         // Edit button
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () => _editTask(task),
//                         ),
//                         // Delete button
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => showDialog(
//                             context: context,
//                             builder: (ctx) => AlertDialog(
//                               title: Text('Delete Task'),
//                               content: Text('Are you sure you want to delete this task?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.of(ctx).pop(),
//                                   child: Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(ctx).pop();
//                                     _deleteTask(task);
//                                   },
//                                   child: Text('Delete', style: TextStyle(color: Colors.red)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TaskDetailScreen(
//                           task: task,
//                           onEdit: _editTask,
//                           onDelete: _deleteTask,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTask,
//         child: Icon(Icons.add),
//         tooltip: 'Add Task',
//       ),
//     );
//   }
// }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/task_model.dart';
// import 'login_screen.dart';
// import 'task_detail_screen.dart';
// import 'task_form_screen.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   late Future<List<Task>> _tasksFuture = _apiService.fetchTasks();
//   final ApiService _apiService = ApiService();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshTasks();
//   }
//
//   // Refresh tasks list with loading indicator
//   Future<void> _refreshTasks() async {
//     setState(() {
//       _isLoading = true;
//       _tasksFuture = _apiService.fetchTasks();
//     });
//
//     try {
//       await _tasksFuture;
//     } catch (e) {
//       // Error will be handled in the FutureBuilder
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   // Logout with error handling
//   Future<void> _logout() async {
//     try {
//       setState(() => _isLoading = true);
//       await _apiService.logout();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Logout issue: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   // Add a new task
//   Future<void> _addTask() async {
//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           onSave: (Task newTask, {File? image, File? file}) async {
//             try {
//               await _apiService.createTaskWithFiles(newTask, image: image, file: file);
//               return true;
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to add task: ${e.toString()}')),
//               );
//               return false;
//             }
//           },
//         ),
//       ),
//     );
//
//     if (result == true) {
//       _refreshTasks();
//     }
//   }
//
//   // Edit an existing task
//   Future<void> _editTask(Task task) async {
//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder: (context) => TaskFormScreen(
//           task: task,
//           onSave: (Task updatedTask, {File? image, File? file}) async {
//             try {
//               await _apiService.updateTaskWithFiles(updatedTask, image: image, file: file);
//               return true;
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//               );
//               return false;
//             }
//           },
//         ),
//       ),
//     );
//
//     if (result == true) {
//       _refreshTasks();
//     }
//   }
//
//   // Delete a task with confirmation
//   Future<void> _deleteTask(Task task) async {
//     if (task.id == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Cannot delete task: Invalid task ID')),
//       );
//       return;
//     }
//
//     try {
//       setState(() => _isLoading = true);
//       await _apiService.deleteTask(task.id!);
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Task deleted successfully')),
//         );
//         _refreshTasks();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to delete task: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   // Toggle task completion status
//   Future<void> _toggleTaskCompletion(Task task) async {
//     try {
//       setState(() => _isLoading = true);
//       await _apiService.toggleTaskCompletion(task);
//       _refreshTasks();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update task: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Tasks'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _isLoading ? null : _refreshTasks,
//             tooltip: 'Refresh Tasks',
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _isLoading ? null : _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: _refreshTasks,
//             child: FutureBuilder<List<Task>>(
//               future: _tasksFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error_outline, color: Colors.red, size: 60),
//                         SizedBox(height: 16),
//                         Text(
//                           'Error loading tasks',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: _refreshTasks,
//                           child: Text('Try Again'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 final tasks = snapshot.data ?? [];
//
//                 if (tasks.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.task_alt, color: Colors.grey, size: 60),
//                         SizedBox(height: 16),
//                         Text(
//                           'No tasks available',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: _addTask,
//                           child: Text('Add Your First Task'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = tasks[index];
//                     return _buildTaskCard(task);
//                   },
//                 );
//               },
//             ),
//           ),
//
//           // Overlay loading indicator when operations are in progress
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _isLoading ? null : _addTask,
//         child: Icon(Icons.add),
//         tooltip: 'Add Task',
//       ),
//     );
//   }
//
//   Widget _buildTaskCard(Task task) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(
//           color: task.isCompleted ? Colors.green.withOpacity(0.5) : Colors.transparent,
//           width: task.isCompleted ? 1 : 0,
//         ),
//       ),
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TaskDetailScreen(
//               task: task,
//               onEdit: _editTask,
//               onDelete: _deleteTask,
//             ),
//           ),
//         ).then((_) => _refreshTasks()),
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Task completion checkbox
//               IconButton(
//                 icon: Icon(
//                   task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
//                   color: task.isCompleted ? Colors.green : Colors.grey,
//                   size: 28,
//                 ),
//                 onPressed: () => _toggleTaskCompletion(task),
//               ),
//
//               // Task image (if available)
//               if (task.imageUrl != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: Image.network(
//                     task.imageUrl!,
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Container(
//                           width: 50,
//                           height: 50,
//                           color: Colors.grey.shade200,
//                           child: Icon(Icons.image_not_supported, color: Colors.grey),
//                         ),
//                   ),
//                 ),
//
//               SizedBox(width: 12),
//
//               // Task details (title, description)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       task.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         decoration: task.isCompleted ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       task.description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 14,
//                       ),
//                     ),
//                     if (task.dueDate != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Row(
//                           children: [
//                             Icon(Icons.calendar_today, size: 12, color: Colors.grey),
//                             SizedBox(width: 4),
//                             Text(
//                               '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
//                               style: TextStyle(fontSize: 12, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               // Action buttons
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => _editTask(task),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => _showDeleteDialog(task),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showDeleteDialog(Task task) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Task'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Are you sure you want to delete this task?'),
//                 SizedBox(height: 8),
//                 Text(
//                   task.title,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   task.description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteTask(task);
//               },
//               child: Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import 'login_screen.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasksFuture = _apiService.fetchTasks();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _isLoading = true;
      _tasksFuture = _apiService.fetchTasks();
    });

    try {
      await _tasksFuture;
    } catch (e) {
      // Error will be handled in the FutureBuilder
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      setState(() => _isLoading = true);
      await _apiService.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout issue: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addTask() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          onSave: (Task newTask, {File? image, File? file}) async {
            try {
              await _apiService.createTaskWithFiles(newTask, image: image, file: file);
              return true;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add task: ${e.toString()}')),
              );
              return false;
            }
          },
        ),
      ),
    );

    if (result == true) {
      _refreshTasks();
    }
  }

  Future<void> _editTask(Task task) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          task: task,
          onSave: (Task updatedTask, {File? image, File? file}) async {
            try {
              await _apiService.updateTaskWithFiles(updatedTask, image: image, file: file);
              return true;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update task: ${e.toString()}')),
              );
              return false;
            }
          },
        ),
      ),
    );

    if (result == true) {
      _refreshTasks();
    }
  }

  Future<void> _deleteTask(Task task) async {
    if (task.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot delete task: Invalid task ID')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _apiService.deleteTask(task.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task deleted successfully')),
        );
        _refreshTasks();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      setState(() => _isLoading = true);
      await _apiService.toggleTaskCompletion(task);
      _refreshTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.task_alt, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'My Tasks',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.refresh, color: Colors.white),
                              onPressed: _isLoading ? null : _refreshTasks,
                              tooltip: 'Refresh Tasks',
                            ),
                            IconButton(
                              icon: Icon(Icons.logout, color: Colors.white),
                              onPressed: _isLoading ? null : _logout,
                              tooltip: 'Logout',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Task List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshTasks,
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          child: FutureBuilder<List<Task>>(
                            future: _tasksFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.red, size: 70),
                                        SizedBox(height: 24),
                                        Text(
                                          'Error loading tasks',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'There was a problem connecting to the server.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                        ),
                                        SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: _refreshTasks,
                                          icon: Icon(Icons.refresh),
                                          label: Text('Try Again'),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final tasks = snapshot.data ?? [];

                              if (tasks.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 70),
                                        SizedBox(height: 24),
                                        Text(
                                          'No Tasks Yet',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Create your first task to get started!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                        ),
                                        SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: _addTask,
                                          icon: Icon(Icons.add),
                                          label: Text('Add Your First Task'),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.only(top: 16, bottom: 100),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return _buildTaskCard(task);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Action Button
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton.extended(
                  onPressed: _isLoading ? null : _addTask,
                  icon: Icon(Icons.add),
                  label: Text('Add Task'),
                  elevation: 6,
                ),
              ),

              // Overlay loading indicator
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Please wait...'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    // Determine appropriate color based on priority if available
    Color priorityColor = Colors.blue;
    if (task.priority != null) {
      if (task.priority!.toLowerCase() == 'high') {
        priorityColor = Colors.red;
      } else if (task.priority!.toLowerCase() == 'medium') {
        priorityColor = Colors.orange;
      } else if (task.priority!.toLowerCase() == 'low') {
        priorityColor = Colors.green;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: task.isCompleted ? Colors.green.withOpacity(0.5) : Colors.transparent,
          width: task.isCompleted ? 1 : 0,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(
              task: task,
              onEdit: _editTask,
              onDelete: _deleteTask,
            ),
          ),
        ).then((_) => _refreshTasks()),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Task completion checkbox
              InkWell(
                onTap: () => _toggleTaskCompletion(task),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted ? Colors.green.withOpacity(0.1) : Colors.transparent,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                    size: 28,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Task image (if available)
              if (task.imageUrl != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      task.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

              if (task.imageUrl != null) SizedBox(width: 12),

              // Task details (title, description)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (task.priority != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: priorityColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              task.priority!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: priorityColor,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        if (task.dueDate != null) ...[
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                        Spacer(),
                        if (task.fileUrl != null)
                          Icon(
                            Icons.attach_file,
                            size: 14,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => _editTask(task),
                    iconSize: 22,
                    splashRadius: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showDeleteDialog(task),
                    iconSize: 22,
                    splashRadius: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(Task task) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Task'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to delete this task?'),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_outline, size: 18),
              label: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask(task);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
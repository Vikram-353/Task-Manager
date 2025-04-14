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
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Theme.of(context).primaryColor.withOpacity(0.8),
//               Theme.of(context).colorScheme.secondary.withOpacity(0.7),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   // Custom App Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.task_alt, color: Colors.white, size: 28),
//                             SizedBox(width: 12),
//                             Text(
//                               'My Tasks',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.refresh, color: Colors.white),
//                               onPressed: _isLoading ? null : _refreshTasks,
//                               tooltip: 'Refresh Tasks',
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.logout, color: Colors.white),
//                               onPressed: _isLoading ? null : _logout,
//                               tooltip: 'Logout',
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Task List
//                   Expanded(
//                     child: RefreshIndicator(
//                       onRefresh: _refreshTasks,
//                       child: Container(
//                         margin: EdgeInsets.only(top: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(24),
//                             topRight: Radius.circular(24),
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(24),
//                             topRight: Radius.circular(24),
//                           ),
//                           child: FutureBuilder<List<Task>>(
//                             future: _tasksFuture,
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
//                                 return Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }
//
//                               if (snapshot.hasError) {
//                                 return Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(24.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.error_outline, color: Colors.red, size: 70),
//                                         SizedBox(height: 24),
//                                         Text(
//                                           'Error loading tasks',
//                                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(height: 16),
//                                         Text(
//                                           'There was a problem connecting to the server.',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                                         ),
//                                         SizedBox(height: 24),
//                                         ElevatedButton.icon(
//                                           onPressed: _refreshTasks,
//                                           icon: Icon(Icons.refresh),
//                                           label: Text('Try Again'),
//                                           style: ElevatedButton.styleFrom(
//                                             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//
//                               final tasks = snapshot.data ?? [];
//
//                               if (tasks.isEmpty) {
//                                 return Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(24.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 70),
//                                         SizedBox(height: 24),
//                                         Text(
//                                           'No Tasks Yet',
//                                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(height: 16),
//                                         Text(
//                                           'Create your first task to get started!',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                                         ),
//                                         SizedBox(height: 24),
//                                         ElevatedButton.icon(
//                                           onPressed: _addTask,
//                                           icon: Icon(Icons.add),
//                                           label: Text('Add Your First Task'),
//                                           style: ElevatedButton.styleFrom(
//                                             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//
//                               return ListView.builder(
//                                 padding: EdgeInsets.only(top: 16, bottom: 100),
//                                 itemCount: tasks.length,
//                                 itemBuilder: (context, index) {
//                                   final task = tasks[index];
//                                   return _buildTaskCard(task);
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Floating Action Button
//               Positioned(
//                 right: 20,
//                 bottom: 20,
//                 child: FloatingActionButton.extended(
//                   onPressed: _isLoading ? null : _addTask,
//                   icon: Icon(Icons.add),
//                   label: Text('Add Task'),
//                   elevation: 6,
//                 ),
//               ),
//
//               // Overlay loading indicator
//               if (_isLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.3),
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 10,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text('Please wait...'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskCard(Task task) {
//     // Determine appropriate color based on priority if available
//     Color priorityColor = Colors.blue;
//     if (task.priority != null) {
//       if (task.priority!.toLowerCase() == 'high') {
//         priorityColor = Colors.red;
//       } else if (task.priority!.toLowerCase() == 'medium') {
//         priorityColor = Colors.orange;
//       } else if (task.priority!.toLowerCase() == 'low') {
//         priorityColor = Colors.green;
//       }
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 8,
//             offset: Offset(0, 3),
//           ),
//         ],
//         border: Border.all(
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
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Task completion checkbox
//               InkWell(
//                 onTap: () => _toggleTaskCompletion(task),
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: task.isCompleted ? Colors.green.withOpacity(0.1) : Colors.transparent,
//                   ),
//                   padding: EdgeInsets.all(4),
//                   child: Icon(
//                     task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
//                     color: task.isCompleted ? Colors.green : Colors.grey,
//                     size: 28,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//
//               // Task image (if available)
//               if (task.imageUrl != null)
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       task.imageUrl!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey.shade200,
//                         child: Icon(Icons.image_not_supported, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//
//               if (task.imageUrl != null) SizedBox(width: 12),
//
//               // Task details (title, description)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         if (task.priority != null)
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                             margin: EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               color: priorityColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: priorityColor.withOpacity(0.5)),
//                             ),
//                             child: Text(
//                               task.priority!,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: priorityColor,
//                               ),
//                             ),
//                           ),
//                         Expanded(
//                           child: Text(
//                             task.title,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               decoration: task.isCompleted ? TextDecoration.lineThrough : null,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       task.description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 14,
//                         height: 1.3,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Row(
//                       children: [
//                         if (task.dueDate != null) ...[
//                           Icon(Icons.calendar_today, size: 12, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(
//                             '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                         Spacer(),
//                         if (task.fileUrl != null)
//                           Icon(
//                             Icons.attach_file,
//                             size: 14,
//                             color: Colors.grey,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Action buttons
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit_outlined, color: Colors.blue),
//                     onPressed: () => _editTask(task),
//                     iconSize: 22,
//                     splashRadius: 24,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete_outline, color: Colors.red),
//                     onPressed: () => _showDeleteDialog(task),
//                     iconSize: 22,
//                     splashRadius: 24,
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
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.red),
//               SizedBox(width: 8),
//               Text('Delete Task'),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Are you sure you want to delete this task?'),
//                 SizedBox(height: 16),
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         task.title,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         task.description,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//               style: TextButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             ElevatedButton.icon(
//               icon: Icon(Icons.delete_outline, size: 18),
//               label: Text('Delete'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteTask(task);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
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

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late Future<List<Task>> _tasksFuture = _apiService.fetchTasks();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _filterStatus = 'all'; // 'all', 'completed', 'pending'
  String _filterPriority = 'all'; // 'all', 'high', 'medium', 'low'
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // For batch operations
  List<Task> _selectedTasks = [];
  bool _batchMode = false;

  // For sorting
  String _sortBy = 'dueDate'; // 'dueDate', 'priority', 'title'
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
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

  // New batch operations methods
  void _toggleBatchMode() {
    setState(() {
      _batchMode = !_batchMode;
      if (!_batchMode) {
        _selectedTasks.clear();
      }
    });
  }

  void _toggleTaskSelection(Task task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  Future<void> _batchDeleteTasks() async {
    if (_selectedTasks.isEmpty) return;

    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selectedTasks.length} Tasks'),
        content: Text('Are you sure you want to delete ${_selectedTasks.length} tasks? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      setState(() => _isLoading = true);

      for (final task in _selectedTasks) {
        if (task.id != null) {
          await _apiService.deleteTask(task.id!);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_selectedTasks.length} tasks deleted')),
      );

      // Exit batch mode and refresh
      setState(() {
        _batchMode = false;
        _selectedTasks.clear();
      });
      _refreshTasks();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete tasks: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _batchMarkAsCompleted(bool completed) async {
    if (_selectedTasks.isEmpty) return;

    try {
      setState(() => _isLoading = true);

      for (final task in _selectedTasks) {
        final updatedTask = task.copyWith(isCompleted: completed);
        await _apiService.toggleTaskCompletion(updatedTask);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_selectedTasks.length} tasks updated')),
      );

      // Exit batch mode and refresh
      setState(() {
        _batchMode = false;
        _selectedTasks.clear();
      });
      _refreshTasks();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update tasks: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (_showSearchBar) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  // Filter and sort tasks
  List<Task> _filterAndSortTasks(List<Task> tasks) {
    // First apply filters
    var filteredTasks = tasks.where((task) {
      bool matchesStatus = true;
      if (_filterStatus == 'completed') {
        matchesStatus = task.isCompleted;
      } else if (_filterStatus == 'pending') {
        matchesStatus = !task.isCompleted;
      }

      bool matchesPriority = true;
      if (_filterPriority != 'all' && task.priority != null) {
        matchesPriority = task.priority!.toLowerCase() == _filterPriority;
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }

      return matchesStatus && matchesPriority && matchesSearch;
    }).toList();

    // Then sort
    filteredTasks.sort((a, b) {
      int result;

      switch (_sortBy) {
        case 'dueDate':
          if (a.dueDate == null && b.dueDate == null) {
            result = 0;
          } else if (a.dueDate == null) {
            result = 1;
          } else if (b.dueDate == null) {
            result = -1;
          } else {
            result = a.dueDate!.compareTo(b.dueDate!);
          }
          break;

        case 'priority':
          final priorityOrder = {'high': 0, 'medium': 1, 'low': 2, null: 3};
          final aPriority = a.priority?.toLowerCase();
          final bPriority = b.priority?.toLowerCase();
          result = (priorityOrder[aPriority] ?? 3).compareTo(priorityOrder[bPriority] ?? 3);
          break;

        case 'title':
        default:
          result = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }

      return _sortAscending ? result : -result;
    });

    return filteredTasks;
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSortOption('Due Date', 'dueDate', setModalState),
                  _buildSortOption('Priority', 'priority', setModalState),
                  _buildSortOption('Title', 'title', setModalState),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Direction: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          setModalState(() {
                            _sortAscending = true;
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _sortAscending ? Theme.of(context).primaryColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                size: 16,
                                color: _sortAscending ? Colors.white : Colors.grey[600],
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Ascending',
                                style: TextStyle(
                                  color: _sortAscending ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          setModalState(() {
                            _sortAscending = false;
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_sortAscending ? Theme.of(context).primaryColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 16,
                                color: !_sortAscending ? Colors.white : Colors.grey[600],
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Descending',
                                style: TextStyle(
                                  color: !_sortAscending ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Apply'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildSortOption(String label, String value, StateSetter setModalState) {
    final isSelected = _sortBy == value;

    return InkWell(
      onTap: () {
        setModalState(() {
          _sortBy = value;
        });
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', _filterStatus == 'all', () {
                    setState(() => _filterStatus = 'all');
                  }),
                  _buildFilterChip('Pending', _filterStatus == 'pending', () {
                    setState(() => _filterStatus = 'pending');
                  }),
                  _buildFilterChip('Completed', _filterStatus == 'completed', () {
                    setState(() => _filterStatus = 'completed');
                  }),
                  // VerticalDivider(width: 20, thickness: 1),
                  // _buildFilterChip('Any Priority', _filterPriority == 'all', () {
                  //   setState(() => _filterPriority = 'all');
                  // }),
                  _buildFilterChip('High', _filterPriority == 'high', () {
                    setState(() => _filterPriority = 'high');
                  }),
                  _buildFilterChip('Medium', _filterPriority == 'medium', () {
                    setState(() => _filterPriority = 'medium');
                  }),
                  _buildFilterChip('Low', _filterPriority == 'low', () {
                    setState(() => _filterPriority = 'low');
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
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
                            // Search icon
                            IconButton(
                              icon: Icon(_showSearchBar ? Icons.close : Icons.search, color: Colors.white),
                              onPressed: _toggleSearchBar,
                              tooltip: _showSearchBar ? 'Close Search' : 'Search Tasks',
                            ),
                            // Sort icon
                            IconButton(
                              icon: Icon(Icons.sort, color: Colors.white),
                              onPressed: _showSortDialog,
                              tooltip: 'Sort Tasks',
                            ),
                            // Batch select mode toggle
                            // IconButton(
                            //   icon: Icon(_batchMode ? Icons.cancel : Icons.select_all, color: Colors.white),
                            //   onPressed: _toggleBatchMode,
                            //   tooltip: _batchMode ? 'Cancel Selection' : 'Select Multiple',
                            // ),
                            // IconButton(
                            //   icon: Icon(Icons.refresh, color: Colors.white),
                            //   onPressed: _isLoading ? null : _refreshTasks,
                            //   tooltip: 'Refresh Tasks',
                            // ),
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

                  // Search Bar
                  if (_showSearchBar) _buildSearchBar(),

                  // Filter Bar
                  _buildFilterBar(),

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

                              final allTasks = snapshot.data ?? [];
                              final tasks = _filterAndSortTasks(allTasks);

                              if (allTasks.isEmpty) {
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

                              if (tasks.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.filter_list_off, color: Colors.grey[400], size: 70),
                                        SizedBox(height: 24),
                                        Text(
                                          'No Matching Tasks',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Try changing your filters or search',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                        ),
                                        SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _filterStatus = 'all';
                                              _filterPriority = 'all';
                                              _searchQuery = '';
                                              _searchController.clear();
                                              if (_showSearchBar) {
                                                _toggleSearchBar();
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.clear_all),
                                          label: Text('Clear Filters'),
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

                              return Column(
                                children: [
                                  // Task count summary
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'} ${_filterStatus != 'all' || _filterPriority != 'all' || _searchQuery.isNotEmpty ? '(filtered)' : ''}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (_batchMode && _selectedTasks.isNotEmpty)
                                          Text(
                                            '${_selectedTasks.length} selected',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Batch action buttons
                                  if (_batchMode && _selectedTasks.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.check_circle_outline, size: 16),
                                              label: Text('Mark Complete'),
                                              onPressed: () => _batchMarkAsCompleted(true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.highlight_off, size: 16),
                                              label: Text('Mark Pending'),
                                              onPressed: () => _batchMarkAsCompleted(false),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.delete_outline, size: 16),
                                              label: Text('Delete'),
                                              onPressed: _batchDeleteTasks,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Task list
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(bottom: 100), // Give space for FAB
                                      itemCount: tasks.length,
                                      itemBuilder: (context, index) {
                                        final task = tasks[index];
                                        return _buildTaskItem(task);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _batchMode
          ? null
          : FloatingActionButton.extended(
        onPressed: _addTask,
        icon: Icon(Icons.add),
        label: Text('Add Task'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final bool isDueToday = task.dueDate != null &&
        DateUtils.isSameDay(task.dueDate!, DateTime.now());
    final bool isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !DateUtils.isSameDay(task.dueDate!, DateTime.now()) &&
        !task.isCompleted;

    Color getPriorityColor() {
      if (task.priority == null) return Colors.grey;
      switch (task.priority!.toLowerCase()) {
        case 'high': return Colors.red;
        case 'medium': return Colors.orange;
        case 'low': return Colors.green;
        default: return Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _selectedTasks.contains(task)
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _batchMode
              ? () => _toggleTaskSelection(task)
              : () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
              task: task,
              onEdit: _editTask,
              onDelete: _deleteTask,
            ),
              ),
            );

            if (result == true) {
              _refreshTasks();
            }
          },
          onLongPress: !_batchMode ? () => _toggleBatchMode() : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox or selection indicator
                    _batchMode
                        ? Icon(
                      _selectedTasks.contains(task)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedTasks.contains(task)
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      size: 24,
                    )
                        : InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _toggleTaskCompletion(task),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: task.isCompleted
                              ? null
                              : Border.all(
                            color: getPriorityColor(),
                            width: 2,
                          ),
                          color: task.isCompleted
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.all(2),
                        child: task.isCompleted
                            ? Icon(Icons.check, color: Colors.white, size: 18)
                            : SizedBox(width: 18, height: 18),
                      ),
                    ),
                    SizedBox(width: 16),

                    // Task content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? Colors.grey : Colors.black,
                            ),
                          ),
                          if (task.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          SizedBox(height: 8),

                          // Task metadata (due date, attachments, priority)
                          Row(
                            children: [
                              if (task.dueDate != null) ...[
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: isOverdue
                                      ? Colors.red
                                      : isDueToday
                                      ? Colors.orange
                                      : Colors.grey[600],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isOverdue
                                        ? Colors.red
                                        : isDueToday
                                        ? Colors.orange
                                        : Colors.grey[600],
                                    fontWeight: isOverdue || isDueToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 12),
                              ],
                              if (task.priority != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: getPriorityColor().withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: getPriorityColor().withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    task.priority!.capitalize(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: getPriorityColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],

                              // Category or tag if available

                            ],
                          ),
                        ],
                      ),
                    ),

                    // Options menu
                    if (!_batchMode)
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editTask(task);
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(task);
                          } else if (value == 'toggle') {
                            _toggleTaskCompletion(task);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  task.isCompleted
                                      ? Icons.radio_button_unchecked
                                      : Icons.check_circle_outline,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(task.isCompleted ? 'Mark as Pending' : 'Mark as Complete'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteTask(task);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
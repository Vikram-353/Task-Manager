// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/task_model.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final Task task;
//
//   const TaskDetailScreen({Key? key, required this.task}) : super(key: key);
//
//   void _openFileUrl(BuildContext context, String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open file')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(task.title, style: textStyle.titleLarge),
//                 SizedBox(height: 10),
//                 Text(task.description, style: textStyle.bodyLarge),
//                 SizedBox(height: 20),
//
//                 Row(
//                   children: [
//                     Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       task.isCompleted ? 'Completed' : 'Pending',
//                       style: TextStyle(
//                         color: task.isCompleted ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//
//                 if (task.priority != null)
//                   Row(
//                     children: [
//                       Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text(task.priority!),
//                     ],
//                   ),
//
//                 if (task.dueDate != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Due Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.dueDate!.toString()),
//                       ],
//                     ),
//                   ),
//
//                 if (task.createdAt != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Created At: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.createdAt!),
//                       ],
//                     ),
//                   ),
//
//                 if (task.imageUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(task.imageUrl!, height: 200, fit: BoxFit.cover),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 if (task.fileUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('File:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 8),
//                         ElevatedButton.icon(
//                           onPressed: () => _openFileUrl(context, task.fileUrl!),
//                           icon: Icon(Icons.attach_file),
//                           label: Text('Open File'),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/task_model.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final Task task;
//   final Function(Task) onEdit;
//   final Function(Task) onDelete;
//
//   const TaskDetailScreen({
//     Key? key,
//     required this.task,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   void _openFileUrl(BuildContext context, String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open file')),
//       );
//     }
//   }
//
//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete this task?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               onDelete(task);
//               Navigator.of(context).pop(); // go back after deletion
//             },
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () => onEdit(task),
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () => _confirmDelete(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(task.title, style: textStyle.titleLarge),
//                 SizedBox(height: 10),
//                 Text(task.description, style: textStyle.bodyLarge),
//                 SizedBox(height: 20),
//
//                 Row(
//                   children: [
//                     Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       task.isCompleted ? 'Completed' : 'Pending',
//                       style: TextStyle(
//                         color: task.isCompleted ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//
//                 if (task.priority != null)
//                   Row(
//                     children: [
//                       Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text(task.priority!),
//                     ],
//                   ),
//
//                 if (task.dueDate != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Due Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.dueDate!.toString()),
//                       ],
//                     ),
//                   ),
//
//                 if (task.createdAt != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Created At: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.createdAt!),
//                       ],
//                     ),
//                   ),
//
//                 if (task.imageUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(task.imageUrl!, height: 200, fit: BoxFit.cover),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 if (task.fileUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('File:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 8),
//                         ElevatedButton.icon(
//                           onPressed: () => _openFileUrl(context, task.fileUrl!),
//                           icon: Icon(Icons.attach_file),
//                           label: Text('Open File'),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/task_model.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final Task task;
//   final Function(Task) onEdit; // Edit callback
//   final Function(Task) onDelete; // Delete callback
//
//   const TaskDetailScreen({
//     Key? key,
//     required this.task,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   void _openFileUrl(BuildContext context, String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open file')),
//       );
//     }
//   }
//
//   // Confirm delete action with a dialog
//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete this task?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(), // Cancel
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               onDelete(task); // Call the delete function
//               Navigator.of(context).pop(); // Go back after deletion
//             },
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () => onEdit(task), // Handle edit action
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () => _confirmDelete(context), // Handle delete action
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(task.title, style: textStyle.titleLarge),
//                 SizedBox(height: 10),
//                 Text(task.description, style: textStyle.bodyLarge),
//                 SizedBox(height: 20),
//
//                 Row(
//                   children: [
//                     Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       task.isCompleted ? 'Completed' : 'Pending',
//                       style: TextStyle(
//                         color: task.isCompleted ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//
//                 if (task.priority != null)
//                   Row(
//                     children: [
//                       Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text(task.priority!),
//                     ],
//                   ),
//
//                 if (task.dueDate != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Due Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.dueDate!.toString()),
//                       ],
//                     ),
//                   ),
//
//                 if (task.createdAt != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Row(
//                       children: [
//                         Text('Created At: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(task.createdAt!),
//                       ],
//                     ),
//                   ),
//
//                 if (task.imageUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(task.imageUrl!, height: 200, fit: BoxFit.cover),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 if (task.fileUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('File:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 8),
//                         ElevatedButton.icon(
//                           onPressed: () => _openFileUrl(context, task.fileUrl!),
//                           icon: Icon(Icons.attach_file),
//                           label: Text('Open File'),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/task_model.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final Task task;
//   final Function(Task) onEdit;
//   final Function(Task) onDelete;
//
//   const TaskDetailScreen({
//     Key? key,
//     required this.task,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//
//   void _openFileUrl(BuildContext context, String url) async {
//     final Uri uri = Uri.parse(url);
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication); // Force open in browser
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open file: $url')),
//       );
//     }
//   }
//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete this task?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               onDelete(task);
//               Navigator.of(context).pop();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
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
//               Theme.of(context).primaryColor.withOpacity(0.6),
//               Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Custom App Bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     Text(
//                       'Task Details',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.white),
//                           onPressed: () => onEdit(task),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.white),
//                           onPressed: () => _confirmDelete(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Task Status Indicator
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16.0),
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 decoration: BoxDecoration(
//                   color: task.isCompleted ? Colors.green : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   task.isCompleted ? 'Completed' : 'Pending',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               // Task Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Title
//                           Text(
//                             task.title,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           Divider(height: 30),
//
//                           // Description
//                           Text(
//                             'Description',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: Text(
//                               task.description,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 24),
//
//                           // Task Details
//                           Text(
//                             'Details',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           SizedBox(height: 12),
//
//                           // Priority
//                           if (task.priority != null)
//                             _buildDetailRow(
//                               'Priority',
//                               task.priority!,
//                               Icons.flag_outlined,
//                               _getPriorityColor(task.priority!),
//                             ),
//
//                           // Due Date
//                           if (task.dueDate != null)
//                             _buildDetailRow(
//                               'Due Date',
//                               _formatDate(task.dueDate!),
//                               Icons.calendar_today_outlined,
//                               Colors.blue[700]!,
//                             ),
//
//                           // Created At
//                           if (task.createdAt != null)
//                             _buildDetailRow(
//                               'Created At',
//                               task.createdAt!,
//                               Icons.access_time_outlined,
//                               Colors.grey[700]!,
//                             ),
//
//                           SizedBox(height: 24),
//
//                           // Image
//                           if (task.imageUrl != null) ...[
//                             Text(
//                               'Attached Image',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             Container(
//                               height: 200,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 8,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   task.imageUrl!,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (ctx, error, _) => Center(
//                                     child: Icon(
//                                       Icons.broken_image,
//                                       size: 60,
//                                       color: Colors.grey[400],
//                                     ),
//                                   ),
//                                   loadingBuilder: (ctx, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return Center(
//                                       child: CircularProgressIndicator(
//                                         value: loadingProgress.expectedTotalBytes != null
//                                             ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                             : null,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//
//                           // File
//                           if (task.fileUrl != null) ...[
//                             SizedBox(height: 24),
//                             Text(
//                               'Attached File',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             ElevatedButton.icon(
//                               onPressed: () => _openFileUrl(context, task.fileUrl!),
//                               icon: Icon(Icons.file_present_outlined),
//                               label: Text('Open File'),
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 20),
//           SizedBox(width: 8),
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: color),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getPriorityColor(String priority) {
//     switch (priority.toLowerCase()) {
//       case 'high':
//         return Colors.red;
//       case 'medium':
//         return Colors.orange;
//       case 'low':
//         return Colors.green;
//       default:
//         return Colors.blue;
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

import 'package:flutter/material.dart';
import 'package:taskproject2/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final Function(Task) onEdit;
  final Function(Task) onDelete;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  // Function to download the file
  Future<String> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  // Function to open the downloaded file or file URL
  // void _openFile(BuildContext context, String url) async {
  //   try {
  //     final filePath = await downloadFile(url, './downloaded_file');
  //     // Open the file in the respective viewer
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File downloaded to: $filePath')));
  //   } catch (e) {
  //     // If error occurs during downloading, show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to download the file: $e')));
  //   }
  // }

  // void _openFileUrl(BuildContext context, String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not open file: $url')),
  //     );
  //   }
  // }

  void _openFileUrl(BuildContext context, String url) async {
    // Make sure the URL starts with http or https
    final fullUrl = url.startsWith('http') ? url : '${baseUrl}/media/files/$url';

    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file: $fullUrl')),
      );
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete(task);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
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
              Theme.of(context).primaryColor.withOpacity(0.6),
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () => onEdit(task),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Task Status Indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: task.isCompleted ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Task Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Divider(height: 30),

                          // Description
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Task Details
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12),

                          // Priority
                          if (task.priority != null)
                            _buildDetailRow(
                              'Priority',
                              task.priority!,
                              Icons.flag_outlined,
                              _getPriorityColor(task.priority!),
                            ),

                          // Due Date
                          if (task.dueDate != null)
                            _buildDetailRow(
                              'Due Date',
                              _formatDate(task.dueDate!),
                              Icons.calendar_today_outlined,
                              Colors.blue[700]!,
                            ),

                          // Created At
                          if (task.createdAt != null)
                            _buildDetailRow(
                              'Created At',
                              task.createdAt!,
                              Icons.access_time_outlined,
                              Colors.grey[700]!,
                            ),

                          SizedBox(height: 24),

                          // Image
                          if (task.imageUrl != null) ...[
                            Text(
                              'Attached Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  task.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, _) => Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  loadingBuilder: (ctx, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],

                          // File
                          if (task.fileUrl != null) ...[
                            SizedBox(height: 24),
                            Text(
                              'Attached File',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _openFileUrl(context, task.fileUrl!),
                              icon: Icon(Icons.file_present_outlined),
                              label: Text('Open File'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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

  // Helper method to build rows for task details
  Widget _buildDetailRow(String label, String value, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Helper method to format dates
  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  // Helper method to get priority color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import '../models/task_model.dart';
// import 'package:intl/intl.dart';
//
// class TaskFormScreen extends StatefulWidget {
//   final Task? task; // Null for new task, non-null for editing
//   final Future<bool> Function(Task task, {File? image, File? file}) onSave;
//
//   const TaskFormScreen({
//     Key? key,
//     this.task,
//     required this.onSave,
//   }) : super(key: key);
//
//   @override
//   _TaskFormScreenState createState() => _TaskFormScreenState();
// }
//
// class _TaskFormScreenState extends State<TaskFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   String _priority = 'medium'; // Default priority
//   DateTime? _dueDate;
//   bool _isCompleted = false;
//   File? _selectedImage;
//   File? _selectedFile;
//   String? _existingImageUrl;
//   String? _existingFileUrl;
//   bool _isLoading = false;
//
//   final List<String> _priorities = ['low', 'medium', 'high',];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with existing task data if editing
//     _titleController = TextEditingController(text: widget.task?.title ?? '');
//     _descriptionController = TextEditingController(text: widget.task?.description ?? '');
//
//     if (widget.task != null) {
//       _priority = widget.task!.priority ?? 'medium';
//       _dueDate = widget.task!.dueDate;
//       _isCompleted = widget.task!.isCompleted;
//       _existingImageUrl = widget.task!.imageUrl;
//       _existingFileUrl = widget.task!.fileUrl;
//     }
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     }
//   }
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> _selectDueDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dueDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//
//     if (picked != null && picked != _dueDate) {
//       setState(() {
//         _dueDate = picked;
//       });
//     }
//   }
//
//   Future<void> _saveTask() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       // Create a task object with form data
//       final Task taskData = Task(
//         id: widget.task?.id, // Include ID if editing
//         title: _titleController.text,
//         description: _descriptionController.text,
//         isCompleted: _isCompleted,
//         priority: _priority,
//         dueDate: _dueDate,
//         imageUrl: _selectedImage == null ? _existingImageUrl : null,
//         fileUrl: _selectedFile == null ? _existingFileUrl : null,
//         // createdAt will be handled by API for new tasks
//         createdAt: widget.task?.createdAt,
//       );
//
//       try {
//         // Call the save function provided by parent
//         bool success = await widget.onSave(
//           taskData,
//           image: _selectedImage,
//           file: _selectedFile,
//         );
//
//         if (success && mounted) {
//           Navigator.of(context).pop(true); // Return true to indicate success
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.task != null;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Task' : 'Add Task'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _priority,
//                 decoration: InputDecoration(
//                   labelText: 'Priority',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: _priorities.map((String priority) {
//                   return DropdownMenuItem<String>(
//                     value: priority,
//                     child: Text(priority),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     setState(() {
//                       _priority = newValue;
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 16),
//               InkWell(
//                 onTap: _selectDueDate,
//                 child: InputDecorator(
//                   decoration: InputDecoration(
//                     labelText: 'Due Date',
//                     border: OutlineInputBorder(),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         _dueDate == null
//                             ? 'Select Date'
//                             : DateFormat('yyyy-MM-dd').format(_dueDate!),
//                       ),
//                       Icon(Icons.calendar_today),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isEditing) ...[
//                 SizedBox(height: 16),
//                 CheckboxListTile(
//                   title: Text('Mark as Completed'),
//                   value: _isCompleted,
//                   onChanged: (bool? value) {
//                     if (value != null) {
//                       setState(() {
//                         _isCompleted = value;
//                       });
//                     }
//                   },
//                   controlAffinity: ListTileControlAffinity.leading,
//                 ),
//               ],
//               SizedBox(height: 24),
//               // Image selection
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Task Image (Optional)',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   if (_selectedImage != null)
//                     Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             _selectedImage!,
//                             height: 150,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               _selectedImage = null;
//                             });
//                           },
//                         ),
//                       ],
//                     )
//                   else if (_existingImageUrl != null)
//                     Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             _existingImageUrl!,
//                             height: 150,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Icon(Icons.image_not_supported, size: 150),
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               _existingImageUrl = null;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   SizedBox(height: 8),
//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: Icon(Icons.image),
//                     label: Text(_selectedImage != null || _existingImageUrl != null
//                         ? 'Change Image'
//                         : 'Add Image'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // File selection
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Attachment (Optional)',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   if (_selectedFile != null)
//                     ListTile(
//                       leading: Icon(Icons.insert_drive_file),
//                       title: Text(_selectedFile!.path.split('/').last),
//                       trailing: IconButton(
//                         icon: Icon(Icons.close, color: Colors.red),
//                         onPressed: () {
//                           setState(() {
//                             _selectedFile = null;
//                           });
//                         },
//                       ),
//                     )
//                   else if (_existingFileUrl != null)
//                     ListTile(
//                       leading: Icon(Icons.insert_drive_file),
//                       title: Text(_existingFileUrl!.split('/').last),
//                       trailing: IconButton(
//                         icon: Icon(Icons.close, color: Colors.red),
//                         onPressed: () {
//                           setState(() {
//                             _existingFileUrl = null;
//                           });
//                         },
//                       ),
//                     ),
//                   SizedBox(height: 8),
//                   ElevatedButton.icon(
//                     onPressed: _pickFile,
//                     icon: Icon(Icons.attach_file),
//                     label: Text(_selectedFile != null || _existingFileUrl != null
//                         ? 'Change File'
//                         : 'Add File'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _saveTask,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     isEditing ? 'Update Task' : 'Create Task',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
// import '../models/task_model.dart';
//
// class TaskFormScreen extends StatefulWidget {
//   final Task? task;
//   final Future<bool> Function(Task task, {File? image, File? file}) onSave;
//
//   const TaskFormScreen({
//     Key? key,
//     this.task,
//     required this.onSave,
//   }) : super(key: key);
//
//   @override
//   _TaskFormScreenState createState() => _TaskFormScreenState();
// }
//
// class _TaskFormScreenState extends State<TaskFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   String _priority = 'medium';
//   DateTime? _dueDate;
//   bool _isCompleted = false;
//   File? _selectedImage;
//   File? _selectedFile;
//   String? _existingImageUrl;
//   String? _existingFileUrl;
//   bool _isLoading = false;
//
//   final List<String> _priorities = ['low', 'medium', 'high'];
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.task?.title ?? '');
//     _descriptionController = TextEditingController(text: widget.task?.description ?? '');
//
//     if (widget.task != null) {
//       _priority = widget.task!.priority ?? 'medium';
//       _dueDate = widget.task!.dueDate;
//       _isCompleted = widget.task!.isCompleted;
//       _existingImageUrl = widget.task!.imageUrl;
//       _existingFileUrl = widget.task!.fileUrl;
//     }
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     }
//   }
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> _selectDueDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dueDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//
//     if (picked != null && picked != _dueDate) {
//       setState(() {
//         _dueDate = picked;
//       });
//     }
//   }
//
//   Future<void> _saveTask() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       final Task taskData = Task(
//         id: widget.task?.id,
//         title: _titleController.text,
//         description: _descriptionController.text,
//         isCompleted: _isCompleted,
//         priority: _priority,
//         dueDate: _dueDate,
//         imageUrl: _selectedImage == null ? _existingImageUrl : null,
//         fileUrl: _selectedFile == null ? _existingFileUrl : null,
//         createdAt: widget.task?.createdAt,
//       );
//
//       try {
//         bool success = await widget.onSave(
//           taskData,
//           image: _selectedImage,
//           file: _selectedFile,
//         );
//
//         if (success && mounted) {
//           Navigator.of(context).pop(true);
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.task != null;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Task' : 'Add Task'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Title',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) => value == null || value.isEmpty
//                     ? 'Please enter a title'
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) => value == null || value.isEmpty
//                     ? 'Please enter a description'
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _priority,
//                 decoration: const InputDecoration(
//                   labelText: 'Priority',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: _priorities.map((p) {
//                   return DropdownMenuItem(value: p, child: Text(p));
//                 }).toList(),
//                 onChanged: (value) => setState(() => _priority = value!),
//               ),
//               const SizedBox(height: 16),
//               InkWell(
//                 onTap: _selectDueDate,
//                 child: InputDecorator(
//                   decoration: const InputDecoration(
//                     labelText: 'Due Date',
//                     border: OutlineInputBorder(),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(_dueDate == null
//                           ? 'Select Date'
//                           : DateFormat('YYYY-MM-DD').format(_dueDate!)),
//                       const Icon(Icons.calendar_today),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isEditing) ...[
//                 const SizedBox(height: 16),
//                 CheckboxListTile(
//                   value: _isCompleted,
//                   onChanged: (value) => setState(() => _isCompleted = value!),
//                   title: const Text('Mark as Completed'),
//                   controlAffinity: ListTileControlAffinity.leading,
//                 ),
//               ],
//               const SizedBox(height: 24),
//               _buildImagePicker(),
//               const SizedBox(height: 16),
//               _buildFilePicker(),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _saveTask,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     isEditing ? 'Update Task' : 'Create Task',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Task Image (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         if (_selectedImage != null)
//           Stack(
//             alignment: Alignment.topRight,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.file(_selectedImage!, height: 150, width: double.infinity, fit: BoxFit.cover),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.red),
//                 onPressed: () => setState(() => _selectedImage = null),
//               ),
//             ],
//           )
//         else if (_existingImageUrl != null)
//           Stack(
//             alignment: Alignment.topRight,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(_existingImageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.red),
//                 onPressed: () => setState(() => _existingImageUrl = null),
//               ),
//             ],
//           ),
//         const SizedBox(height: 8),
//         ElevatedButton.icon(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.image),
//           label: Text((_selectedImage != null || _existingImageUrl != null)
//               ? 'Change Image'
//               : 'Add Image'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Attachment (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         if (_selectedFile != null)
//           ListTile(
//             leading: const Icon(Icons.insert_drive_file),
//             title: Text(_selectedFile!.path.split('/').last),
//             trailing: IconButton(
//               icon: const Icon(Icons.close, color: Colors.red),
//               onPressed: () => setState(() => _selectedFile = null),
//             ),
//           )
//         else if (_existingFileUrl != null)
//           ListTile(
//             leading: const Icon(Icons.insert_drive_file),
//             title: Text(_existingFileUrl!.split('/').last),
//             trailing: IconButton(
//               icon: const Icon(Icons.close, color: Colors.red),
//               onPressed: () => setState(() => _existingFileUrl = null),
//             ),
//           ),
//         const SizedBox(height: 8),
//         ElevatedButton.icon(
//           onPressed: _pickFile,
//           icon: const Icon(Icons.attach_file),
//           label: Text((_selectedFile != null || _existingFileUrl != null)
//               ? 'Change File'
//               : 'Add File'),
//         ),
//       ],
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final Future<bool> Function(Task task, {File? image, File? file}) onSave;

  const TaskFormScreen({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _priority = 'medium';
  DateTime? _dueDate;
  bool _isCompleted = false;
  File? _selectedImage;
  File? _selectedFile;
  String? _existingImageUrl;
  String? _existingFileUrl;
  bool _isLoading = false;

  final List<String> _priorities = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');

    if (widget.task != null) {
      _priority = widget.task!.priority ?? 'medium';
      _dueDate = widget.task!.dueDate;
      _isCompleted = widget.task!.isCompleted;
      _existingImageUrl = widget.task!.imageUrl;
      _existingFileUrl = widget.task!.fileUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final Task taskData = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
        priority: _priority,
        dueDate: _dueDate,
        imageUrl: _selectedImage == null ? _existingImageUrl : null,
        fileUrl: _selectedFile == null ? _existingFileUrl : null,
        createdAt: widget.task?.createdAt,
      );

      try {
        bool success = await widget.onSave(
          taskData,
          image: _selectedImage,
          file: _selectedFile,
        );

        if (success && mounted) {
          Navigator.of(context).pop(true);
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

  String _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return '#F44336'; // Red
      case 'medium':
        return '#FF9800'; // Orange
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#FF9800'; // Default orange
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEditing ? Icons.edit_note : Icons.add_task,
                            size: 72,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isEditing ? 'Edit Task' : 'Create New Task',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEditing ? 'Update your task details' : 'Add details for your task',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              prefixIcon: Icon(Icons.title_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a title'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 64),
                                child: Icon(Icons.description_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a description'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _priority,
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              prefixIcon: Icon(Icons.flag_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            items: _priorities.map((p) {
                              return DropdownMenuItem(
                                value: p,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(_getPriorityColor(p).substring(1, 7), radix: 16) + 0xFF000000),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(p[0].toUpperCase() + p.substring(1)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _priority = value!),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: _selectDueDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Due Date',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              child: Text(
                                _dueDate == null
                                    ? 'Select Date'
                                    : DateFormat('yyyy-MM-dd').format(_dueDate!),
                              ),
                            ),
                          ),
                          if (isEditing) ...[
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: CheckboxListTile(
                                value: _isCompleted,
                                onChanged: (value) => setState(() => _isCompleted = value!),
                                title: const Text('Mark as Completed'),
                                secondary: Icon(
                                  _isCompleted ? Icons.check_circle_outline : Icons.circle_outlined,
                                  color: _isCompleted ? Colors.green : Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          _buildImagePicker(context),
                          const SizedBox(height: 16),
                          _buildFilePicker(context),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _saveTask,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isEditing ? 'UPDATE TASK' : 'CREATE TASK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image_outlined, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Task Image (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedImage != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(4),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _selectedImage = null),
                  ),
                ),
              ],
            )
          else if (_existingImageUrl != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _existingImageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(4),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _existingImageUrl = null),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                (_selectedImage != null || _existingImageUrl != null)
                    ? 'Change Image'
                    : 'Add Image',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.grey.shade50
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_file_outlined, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Attachment (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedFile != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedFile!.path.split('/').last,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _selectedFile = null),
                  ),
                ],
              ),
            )
          else if (_existingFileUrl != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _existingFileUrl!.split('/').last,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _existingFileUrl = null),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file_outlined),
              label: Text(
                (_selectedFile != null || _existingFileUrl != null)
                    ? 'Change File'
                    : 'Add File',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.grey.shade50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
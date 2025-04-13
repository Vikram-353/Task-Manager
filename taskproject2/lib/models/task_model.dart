// class Task {
//   final int id;
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final String? dueDate;
//   final String? priority;
//   final String? fileUrl;
//   final String? imageUrl;
//   final String? createdAt;
//
//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.isCompleted,
//     this.dueDate,
//     this.priority,
//     this.fileUrl,
//     this.imageUrl,
//     this.createdAt,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       isCompleted: json['is_completed'],
//       dueDate: json['due_date'],
//       priority: json['priority'],
//       fileUrl: json['file'],
//       imageUrl: json['image'],
//       createdAt: json['created_at'],
//     );
//   }
// }


// Task model
// class Task {
//   final int? id;
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final DateTime? dueDate;
//   final String? priority;
//   final String? imageUrl;
//   final String? fileUrl;
//   final String? createdAt;
//
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
//     this.createdAt,
//
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
//     createdAt: json['created_at'],
//   );
//
//   Map<String, String> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'is_completed': isCompleted.toString(),
//       if (dueDate != null) 'due_date': dueDate!.toIso8601String().split('T')[0],
//       if (priority != null) 'priority': priority!,
//       'imageUrl': imageUrl ?? '',
//       'fileUrl': fileUrl ?? '',
//       'created_at':createdAt??''
//     };
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
// class Task {
//   final int? id;
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final String? priority;
//   final DateTime? dueDate;
//   final String? imageUrl;
//   final String? fileUrl;
//   final String? createdAt;
//
//   Task({
//     this.id,
//     required this.title,
//     required this.description,
//     this.isCompleted = false,
//     this.priority,
//     this.dueDate,
//     this.imageUrl,
//     this.fileUrl,
//     this.createdAt,
//   });
//
//   // Create a copy of this task with updated fields
//   Task copyWith({
//     int? id,
//     String? title,
//     String? description,
//     bool? isCompleted,
//     String? priority,
//     DateTime? dueDate,
//     String? imageUrl,
//     String? fileUrl,
//     String? createdAt,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       isCompleted: isCompleted ?? this.isCompleted,
//       priority: priority ?? this.priority,
//       dueDate: dueDate ?? this.dueDate,
//       imageUrl: imageUrl ?? this.imageUrl,
//       fileUrl: fileUrl ?? this.fileUrl,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
//
//   // Convert task to JSON for API requests
//   Map<String, String> toJson() {
//     final Map<String, String> data = {
//       'title': title,
//       'description': description,
//       'is_completed': isCompleted.toString(),
//     };
//
//     // Add optional fields if they exist
//     if (id != null) data['id'] = id.toString();
//     if (priority != null) data['priority'] = priority!;
//     if (dueDate != null) data['due_date'] = dueDate!.toIso8601String().split('T').first
//
//     return data;
//   }
//
//   // Create task from JSON response
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       isCompleted: json['is_completed'] ?? false,
//       priority: json['priority'],
//       dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
//       imageUrl: json['image'],
//       fileUrl: json['file'],
//       createdAt: json['created_at'],
//     );
//   }
// }
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final String? priority;
  final DateTime? dueDate;
  final String? imageUrl;
  final String? fileUrl;
  final String? createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority,
    this.dueDate,
    this.imageUrl,
    this.fileUrl,
    this.createdAt,
  });

  // Create a copy of this task with updated fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    DateTime? dueDate,
    String? imageUrl,
    String? fileUrl,
    String? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert task to JSON for API requests
  Map<String, String> toJson() {
    final Map<String, String> data = {
      'title': title,
      'description': description,
      'is_completed': isCompleted.toString(),
    };

    if (id != null) data['id'] = id.toString();
    if (priority != null) data['priority'] = priority!;
    if (dueDate != null) {
      data['due_date'] = _formatDate(dueDate!);
    }
    if (imageUrl != null) data['image'] = imageUrl!;
    if (fileUrl != null) data['file'] = fileUrl!;
    if (createdAt != null) data['created_at'] = createdAt!;

    return data;
  }

  // Format DateTime to 'yyyy-MM-dd'
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // Create task from JSON response
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'] == true || json['is_completed'] == 'true',
      priority: json['priority'],
      dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date']) : null,
      imageUrl: json['image'],
      fileUrl: json['file'],
      createdAt: json['created_at'],
    );
  }
}

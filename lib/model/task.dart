import 'dart:convert';

class Task {
  final String description;
  final String id;
  final bool isCompleted;
  final String userId;

  Task({
    required this.description,
    required this.id,
    required this.isCompleted,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toString() ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  Task copyWith({
    String? id,
    String? description,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}

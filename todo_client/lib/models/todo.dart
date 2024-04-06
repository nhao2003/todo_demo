enum Priority {
  low,
  medium,
  high;

  String get dislayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  static Priority fromString(String value) {
    switch (value) {
      case 'Low':
        return Priority.low;
      case 'Medium':
        return Priority.medium;
      case 'High':
        return Priority.high;
      default:
        return Priority.low;
    }
  }
}

class Todo {
  String id;
  String title;
  String description;
  Priority priority;
  bool done;
  DateTime? time;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.done,
    required this.time,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      priority: Priority.fromString(json['priority']),
      done: json['done'],
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'done': done,
      'priority': priority.name,
      'time': time?.toIso8601String(),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      time: time,
    );
  }
}

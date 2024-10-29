enum Priority { low, medium, high }

enum TaskStatus { pending, completed }

class Task {
  int? id;
  String name;
  Priority priority;
  TaskStatus status;
  DateTime creationDate;

  Task({
    this.id,
    required this.name,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priority': priority.index,
      'status': status.index,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      priority: Priority.values[map['priority']],
      status: TaskStatus.values[map['status']],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }
}

import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String text;
  bool isDone;

  Todo({String? id, required this.text, this.isDone = false})
    : id = id ?? const Uuid().v4();

  // Convert Todo to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isDone': isDone};
  }

  // Create Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      text: json['text'] as String,
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}

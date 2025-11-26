import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String text;
  bool isDone;

  Todo({String? id, required this.text, this.isDone = false})
    : id = id ?? const Uuid().v4();
}

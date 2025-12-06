import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  static const String _storageKey = 'todos';

  List<Todo> get todos => _todos;

  // Load todos from shared preferences
  Future<void> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosJson = prefs.getString(_storageKey);

      if (todosJson != null) {
        final List<dynamic> decoded = json.decode(todosJson);
        _todos.clear();
        _todos.addAll(decoded.map((item) => Todo.fromJson(item)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }

  // Save todos to shared preferences
  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        _todos.map((todo) => todo.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  void addTodo(String text) {
    if (text.isEmpty) return;
    _todos.add(Todo(text: text));
    _saveTodos();
    notifyListeners();
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      _saveTodos();
      notifyListeners();
    }
  }

  void clearAllTodos() {
    _todos.clear();
    _saveTodos();
    notifyListeners();
  }
}

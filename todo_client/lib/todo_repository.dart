import 'models/todo.dart';
import 'package:dio/dio.dart';

class TodoRepository {
  late Dio _dio;
  final String _baseUrl = 'http://172.31.192.1:3000';

  TodoRepository() {
    _dio = Dio();
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get('$_baseUrl/todos');
      final todos =
          (response.data as List).map((json) => Todo.fromJson(json)).toList();
      return todos;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await _dio.post('$_baseUrl/todos', data: todo.toJson());
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      print(todo.id);
      await _dio.put('$_baseUrl/todos/${todo.id}', data: todo.toJson());
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await _dio.delete('$_baseUrl/todos/${todo.id}');
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}

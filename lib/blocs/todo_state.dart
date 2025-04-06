import 'package:daily_todo_app/models/todo.dart';

class TodoState {
  final List<Todo> todos;

  TodoState({required this.todos});
}

class TodoErrorState extends TodoState {
  final String error;
  TodoErrorState({required this.error}) : super(todos: []);
}

import '../models/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class RemoveTodo extends TodoEvent {
  final Todo todo;
  RemoveTodo(this.todo);
}

class ToggleTodo extends TodoEvent {
  final Todo todo;
  ToggleTodo(this.todo);
}

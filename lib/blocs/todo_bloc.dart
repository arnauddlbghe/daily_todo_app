import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(todos: [])) {
    on<AddTodo>((event, emit) {
      final updatedTodos =
          List<Todo>.from(state.todos)
            ..add(event.todo)
            ..sort((a, b) => a.date.compareTo(b.date)); // trie par date
      emit(TodoState(todos: updatedTodos));
    });

    on<RemoveTodo>((event, emit) {
      final updatedList = List<Todo>.from(state.todos)..remove(event.todo);
      emit(TodoState(todos: updatedList));
    });

    on<ToggleTodo>((event, emit) {
      final updatedList =
          state.todos.map((todo) {
            if (todo == event.todo) {
              return todo.copyWith(isDone: !todo.isDone);
            }
            return todo;
          }).toList();
      emit(TodoState(todos: updatedList));
    });
  }
}

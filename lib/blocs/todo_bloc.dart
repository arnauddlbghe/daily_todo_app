import 'package:daily_todo_app/blocs/todo_event.dart';
import 'package:daily_todo_app/blocs/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_todo_app/services/database_helper.dart'; // Assurez-vous que ce chemin est correct

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  TodoBloc() : super(TodoState(todos: [])) {
    // Charger les tâches depuis la base de données au démarrage
    on<LoadTodos>((event, emit) async {
      try {
        final todos = await _databaseHelper.getAllTodos();
        emit(TodoState(todos: todos));
      } catch (e) {
        emit(TodoErrorState(error: 'Erreur de chargement'));
      }
    });

    // Ajouter une tâche
    on<AddTodo>((event, emit) async {
      try {
        // Ajouter la tâche à la base de données
        await _databaseHelper.insert(event.todo);

        // Récupérer toutes les tâches mises à jour
        final todos = await _databaseHelper.getAllTodos();
        emit(TodoState(todos: todos));
      } catch (e) {
        emit(TodoErrorState(error: 'Erreur lors de l\'ajout de la tâche'));
      }
    });

    // Supprimer une tâche
    on<RemoveTodo>((event, emit) async {
      try {
        // Supprimer la tâche de la base de données
        await _databaseHelper.delete(event.todo.id!);

        // Récupérer toutes les tâches mises à jour
        final todos = await _databaseHelper.getAllTodos();
        emit(TodoState(todos: todos));
      } catch (e) {
        emit(
          TodoErrorState(error: 'Erreur lors de la suppression de la tâche'),
        );
      }
    });

    // Marquer une tâche comme terminée
    on<ToggleTodo>((event, emit) async {
      try {
        // Modifier l'état de la tâche dans la base de données
        event.todo.isDone = !event.todo.isDone;
        await _databaseHelper.update(event.todo);

        // Récupérer toutes les tâches mises à jour
        final todos = await _databaseHelper.getAllTodos();
        emit(TodoState(todos: todos));
      } catch (e) {
        emit(
          TodoErrorState(error: 'Erreur lors de la mise à jour de la tâche'),
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';
import '../blocs/todo_state.dart';
import '../components/add_todo_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TodoBloc>().add(LoadTodos());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Ma Todo2'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return state.todos.isEmpty
              ? const Center(child: Text("Aucune tâche pour l’instant 😊"))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.todos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) {
                          context.read<TodoBloc>().add(ToggleTodo(todo));
                        },
                      ),
                      title: Text(
                        todo.description,
                        style: TextStyle(
                          fontSize: 16,
                          decoration:
                              todo.isDone ? TextDecoration.lineThrough : null,
                          color: todo.isDone ? Colors.grey : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(todo.date),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          context.read<TodoBloc>().add(RemoveTodo(todo));
                        },
                      ),
                    ),
                  );
                },
              );
        },
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBottomSheet(context),
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _showAddTodoBottomSheet(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTodoSheet(parentContext: parentContext),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    return "${_addZero(d.day)}/${_addZero(d.month)}/${d.year} à ${_addZero(d.hour)}h${_addZero(d.minute)}";
  }

  String _addZero(int n) => n < 10 ? '0$n' : '$n';
}

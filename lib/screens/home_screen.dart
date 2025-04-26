import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';
import '../blocs/todo_state.dart';
import '../components/add_todo_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TodoBloc>().add(
      LoadTodos(),
    ); // Charger les données dès l'ouverture

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  final activeTasks =
                      state.todos.values
                          .expand((e) => e)
                          .where((todo) => !todo.isDone)
                          .length;
                  return Text(
                    '$activeTasks tâches actives',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text(
                "Aucune tâche pour l’instant 😊",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(
              top: 0,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            children:
                state.todos.keys.map((date) {
                  final todos = state.todos[date]!;
                  final formattedDate = DateFormat(
                    'dd/MM/yyyy',
                  ).format(DateTime.parse(date));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: todos.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(height: 10), // espace réduit
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Dismissible(
                            key: Key(todo.id.toString()),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),

                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              context.read<TodoBloc>().add(RemoveTodo(todo));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    todo.isDone
                                        ? Color.fromARGB(255, 179, 237, 200)
                                        : Color.fromARGB(255, 244, 241, 241),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                onTap: () {
                                  context.read<TodoBloc>().add(
                                    ToggleTodo(todo),
                                  );
                                },
                                contentPadding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        todo.description,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          decoration:
                                              todo.isDone
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBottomSheet(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  void _showAddTodoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AddTodoSheet(parentContext: context),
    );
  }
}

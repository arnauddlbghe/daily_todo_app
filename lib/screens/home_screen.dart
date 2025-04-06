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
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          50,
        ), // Réduire la taille de l'AppBar
        child: AppBar(
          title: Row(
            children: [
              Icon(
                Icons
                    .check_circle_outline, // Ajoutez une icône si vous le souhaitez
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'Ma Todo2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing:
                      1.2, // Espacement des lettres pour plus de style
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ], // Ombre légère pour un effet plus moderne
                ),
              ),
            ],
          ),
          backgroundColor:
              Colors.transparent, // Fond transparent pour le dégradé
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.blue], // Dégradé élégant
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          elevation: 4, // Ombre légère sous l'AppBar
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          // Vérifier si la Map est vide
          if (state.todos.isEmpty) {
            return const Center(
              child: Text(
                "Aucune tâche pour l’instant 😊",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children:
                state.todos.keys.map((date) {
                  final todos = state.todos[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre (la date ou autre critère)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          date, // La date ou le titre de la catégorie
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Liste des tâches pour cette date
                      ListView.separated(
                        shrinkWrap:
                            true, // Pour que la ListView ne prenne pas trop de place
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: todos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 6,
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        todo.description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        todo.isDone
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color:
                                            todo.isDone
                                                ? Colors.green
                                                : Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        context.read<TodoBloc>().add(
                                          ToggleTodo(todo),
                                        );
                                      },
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
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, size: 30),
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
      builder: (context) => AddTodoSheet(parentContext: context),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    return "${_addZero(d.day)}/${_addZero(d.month)}/${d.year}";
  }

  String _addZero(int n) => n < 10 ? '0$n' : '$n';
}

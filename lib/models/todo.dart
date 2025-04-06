class Todo {
  final String description;
  final DateTime date;
  final bool isDone;

  Todo({required this.description, required this.date, this.isDone = false});

  Todo copyWith({String? description, DateTime? date, bool? isDone}) {
    return Todo(
      description: description ?? this.description,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }
}

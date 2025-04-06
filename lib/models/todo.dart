class Todo {
  final int? id;
  final String description;
  final DateTime date;
  bool isDone;

  Todo({
    this.id,
    required this.description,
    required this.date,
    required this.isDone,
  });

  // Convertir un objet Todo en Map pour l'ajouter à la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'isDone': isDone ? 1 : 0, // SQLite utilise 1 pour true et 0 pour false
    };
  }

  // Convertir un Map en objet Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isDone: map['isDone'] == 1,
    );
  }
}

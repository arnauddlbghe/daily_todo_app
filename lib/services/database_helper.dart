import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:daily_todo_app/models/todo.dart'; // Assurez-vous que ce chemin est correct

class DatabaseHelper {
  static final _databaseName = "todo_database.db";
  static final _databaseVersion = 1;

  static final table = 'todo_table';

  static final columnId = 'id';
  static final columnDescription = 'description';
  static final columnDate = 'date';
  static final columnIsDone = 'isDone';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Ouvrir ou créer la base de données
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Créer la table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnDescription TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnIsDone INTEGER NOT NULL
    )
    ''');
  }

  // Insérer une tâche
  Future<int> insert(Todo todo) async {
    Database db = await database;
    return await db.insert(table, todo.toMap());
  }

  // Récupérer toutes les tâches
  Future<List<Todo>> getAllTodos() async {
    Database db = await database;
    var result = await db.query(table);
    List<Todo> todos =
        result.isNotEmpty
            ? result.map((todo) => Todo.fromMap(todo)).toList()
            : [];
    todos.sort((a, b) => b.date.compareTo(a.date));
    return todos;
  }

  // Mettre à jour une tâche
  Future<int> update(Todo todo) async {
    Database db = await database;
    return await db.update(
      table,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
  }

  // Supprimer une tâche
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

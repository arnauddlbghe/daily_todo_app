import 'package:daily_todo_app/blocs/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'themes/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    BlocProvider<TodoBloc>(
      create: (_) => TodoBloc(), // Crée l'instance de TodoBloc
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Create and pre-load the provider before the widget tree is built
  // so that saved tasks are available on the first frame.
  final taskProvider = TaskProvider();
  await taskProvider.loadTasks();

  runApp(
    ChangeNotifierProvider.value(
      value: taskProvider,
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Tasks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}

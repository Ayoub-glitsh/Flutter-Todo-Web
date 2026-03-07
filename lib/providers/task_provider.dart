import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

/// Available task filter options.
enum FilterType { all, pending, completed }

/// Manages all task state: CRUD operations, filtering, search, and persistence.
class TaskProvider extends ChangeNotifier {
  static const String _storageKey = 'todo_tasks';

  final _uuid = const Uuid();
  List<Task> _tasks = [];
  FilterType _filter = FilterType.all;
  String _searchQuery = '';

  // ─── Getters ──────────────────────────────────────────────────────────────

  FilterType get filter => _filter;
  String get searchQuery => _searchQuery;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  /// Returns tasks filtered by the active [FilterType] and [searchQuery].
  List<Task> get filteredTasks {
    Iterable<Task> result = _tasks;

    // Apply filter
    if (_filter == FilterType.completed) {
      result = result.where((t) => t.isCompleted);
    } else if (_filter == FilterType.pending) {
      result = result.where((t) => !t.isCompleted);
    }

    // Apply search (case-insensitive)
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where(
        (t) =>
            t.title.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query),
      );
    }

    // Most-recently-created first
    final sorted = result.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  // ─── Initialisation ───────────────────────────────────────────────────────

  /// Loads persisted tasks from SharedPreferences. Call once at app start.
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      _tasks = jsonList
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  /// Persists the current task list to SharedPreferences.
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  // ─── CRUD ─────────────────────────────────────────────────────────────────

  /// Adds a new task with the given [title] and optional [description].
  Future<void> addTask(String title, {String description = ''}) async {
    final task = Task(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    );
    _tasks.add(task);
    notifyListeners();
    await _saveTasks();
  }

  /// Updates an existing task identified by [id].
  Future<void> updateTask(
    String id, {
    required String title,
    required String description,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      title: title.trim(),
      description: description.trim(),
    );
    notifyListeners();
    await _saveTasks();
  }

  /// Deletes the task with the given [id].
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _saveTasks();
  }

  /// Toggles the completion status of the task with the given [id].
  Future<void> toggleComplete(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    notifyListeners();
    await _saveTasks();
  }

  // ─── Filter & Search ─────────────────────────────────────────────────────

  void setFilter(FilterType filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

/// Real-time search field that filters tasks by title or description.
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      // Update filtered list on every keystroke
      onChanged: (value) =>
          context.read<TaskProvider>().setSearchQuery(value),
      decoration: InputDecoration(
        hintText: 'Search tasks…',
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        // Show clear button only when there's text
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 18, color: AppTheme.textSecondary),
                onPressed: () {
                  _controller.clear();
                  context.read<TaskProvider>().setSearchQuery('');
                },
              )
            : null,
      ),
      // Rebuild so clear button appears/disappears
      onEditingComplete: () => setState(() {}),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_form_dialog.dart';

/// Main screen composing all task management components.
///
/// Layout is responsive:
///   - Desktop  (≥ 900 px): content centred, capped at 860 px wide.
///   - Tablet   (≥ 600 px): single column with 24 px side padding.
///   - Mobile   (<  600 px): 16 px side padding (full column).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Gradient header (full width, fixed at top) ─────────────────────
          const AppHeader(),

          // ── Scrollable content ─────────────────────────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine horizontal padding based on screen width
                final width = constraints.maxWidth;
                double sidePad;
                double maxContent;
                if (width >= 900) {
                  sidePad = (width - 860) / 2;
                  maxContent = 860;
                } else if (width >= 600) {
                  sidePad = 24;
                  maxContent = width - 48;
                } else {
                  sidePad = 16;
                  maxContent = width - 32;
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    sidePad, 24, sidePad, 100, // bottom pad for FAB
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContent),
                    child: const _TaskContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ── Floating action button ─────────────────────────────────────────────
      floatingActionButton: _AddTaskFAB(),
    );
  }
}

/// The scrollable content: search bar, filter bar, and the task list.
class _TaskContent extends StatelessWidget {
  const _TaskContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.filteredTasks;
    final isSearching = provider.searchQuery.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Search bar ───────────────────────────────────────────────────────
        const SearchBarWidget(),
        const SizedBox(height: 14),

        // ── Filter bar ───────────────────────────────────────────────────────
        const FilterBar(),
        const SizedBox(height: 20),

        // ── Task count label ─────────────────────────────────────────────────
        _TaskCountLabel(count: tasks.length, isSearching: isSearching),
        const SizedBox(height: 12),

        // ── Task list or empty state ─────────────────────────────────────────
        if (tasks.isEmpty)
          EmptyState(isSearching: isSearching)
        else
          // AnimatedList-like feel via AnimatedSwitcher per-item
          Column(
            children: [
              for (final task in tasks)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: TaskCard(key: ValueKey(task.id), task: task),
                ),
            ],
          ),
      ],
    );
  }
}

/// Small label showing how many tasks match the current view.
class _TaskCountLabel extends StatelessWidget {
  const _TaskCountLabel({required this.count, required this.isSearching});

  final int count;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    String label;
    if (isSearching) {
      label = '$count result${count == 1 ? '' : 's'} found';
    } else {
      switch (provider.filter) {
        case FilterType.completed:
          label = '$count completed task${count == 1 ? '' : 's'}';
        case FilterType.pending:
          label = '$count pending task${count == 1 ? '' : 's'}';
        case FilterType.all:
          label = '$count task${count == 1 ? '' : 's'} total';
      }
    }

    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .labelSmall!
          .copyWith(fontWeight: FontWeight.w600),
    );
  }
}

/// Floating action button with bounce animation that opens the Add Task dialog.
class _AddTaskFAB extends StatefulWidget {
  @override
  State<_AddTaskFAB> createState() => _AddTaskFABState();
}

class _AddTaskFABState extends State<_AddTaskFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => const TaskFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton.extended(
        onPressed: _onTap,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Task',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        elevation: 6,
        // Gradient background via a custom shape + DecoratedBox trick
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      ),
    );
  }
}

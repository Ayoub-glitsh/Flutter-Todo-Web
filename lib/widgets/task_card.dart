import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'task_form_dialog.dart';
import 'delete_confirm_dialog.dart';

/// Animated card representing a single task.
class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final provider = context.read<TaskProvider>();

    // Visual distinction: completed vs pending
    final cardColor = task.isCompleted
        ? AppTheme.completed.withValues(alpha: 0.05)
        : AppTheme.cardBg;
    final borderColor = task.isCompleted
        ? AppTheme.completed.withValues(alpha: 0.35)
        : (_hovering
            ? AppTheme.primary.withValues(alpha: 0.35)
            : AppTheme.border);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Checkbox ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: _AnimatedCheckbox(
                  value: task.isCompleted,
                  onChanged: (_) => provider.toggleComplete(task.id),
                ),
              ),
              const SizedBox(width: 14),

              // ── Content ─────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                          ),
                    ),

                    // Description (optional)
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Created-at date chip
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(task.createdAt),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        if (task.isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.completed.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Done',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.completed,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // ── Action buttons ──────────────────────────────────────────────
              AnimatedOpacity(
                opacity: _hovering ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    _ActionIconButton(
                      icon: Icons.edit_rounded,
                      color: AppTheme.primary,
                      tooltip: 'Edit task',
                      onTap: () => _openEditDialog(context, task),
                    ),
                    const SizedBox(width: 4),
                    _ActionIconButton(
                      icon: Icons.delete_outline_rounded,
                      color: AppTheme.danger,
                      tooltip: 'Delete task',
                      onTap: () => _confirmDelete(context, task),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (_) => TaskFormDialog(existingTask: task),
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmDialog(task: task),
    );
  }
}

/// Smooth animated checkbox with scale + color transition.
class _AnimatedCheckbox extends StatefulWidget {
  const _AnimatedCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  State<_AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<_AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _ctrl.forward();
    widget.onChanged(!widget.value);
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.value ? AppTheme.completed : Colors.transparent,
            border: Border.all(
              color: widget.value ? AppTheme.completed : AppTheme.textSecondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: widget.value
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

/// Icon button with hover highlight used for Edit / Delete.
class _ActionIconButton extends StatefulWidget {
  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _hovering ? widget.color.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, size: 18, color: widget.color),
          ),
        ),
      ),
    );
  }
}


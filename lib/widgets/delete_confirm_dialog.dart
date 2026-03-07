import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

/// Confirmation dialog shown before permanently deleting a task.
class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.danger,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text('Delete Task',
              style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete:',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          // Task title preview
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.danger.withValues(alpha: 0.2)),
            ),
            child: Text(
              task.title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This action cannot be undone.',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: AppTheme.danger),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            context.read<TaskProvider>().deleteTask(task.id);
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.delete_rounded, size: 16),
          label: const Text('Delete'),
        ),
      ],
    );
  }
}


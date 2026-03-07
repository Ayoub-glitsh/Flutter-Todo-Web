import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

/// Dialog for adding a new task or editing an existing one.
///
/// Pass [existingTask] to pre-fill fields for editing.
class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({super.key, this.existingTask});

  final Task? existingTask;

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl =
        TextEditingController(text: widget.existingTask?.title ?? '');
    _descCtrl =
        TextEditingController(text: widget.existingTask?.description ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final provider = context.read<TaskProvider>();
    if (_isEditing) {
      await provider.updateTask(
        widget.existingTask!.id,
        title: _titleCtrl.text,
        description: _descCtrl.text,
      );
    } else {
      await provider.addTask(
        _titleCtrl.text,
        description: _descCtrl.text,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isEditing ? Icons.edit_rounded : Icons.add_task_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _isEditing ? 'Edit Task' : 'New Task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title field ──────────────────────────────────────────────
              TextFormField(
                controller: _titleCtrl,
                autofocus: true,
                maxLength: 100,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Task title *',
                  prefixIcon: Icon(Icons.title_rounded,
                      size: 18, color: AppTheme.textSecondary),
                  counterText: '',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter a task title.';
                  }
                  if (v.trim().length > 100) {
                    return 'Title must be 100 characters or fewer.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),

              const SizedBox(height: 14),

              // ── Description field ────────────────────────────────────────
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes_rounded,
                        size: 18, color: AppTheme.textSecondary),
                  ),
                  counterText: '',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Icon(_isEditing ? Icons.save_rounded : Icons.add_rounded,
                  size: 16),
          label: Text(_isEditing ? 'Save Changes' : 'Add Task'),
        ),
      ],
    );
  }
}

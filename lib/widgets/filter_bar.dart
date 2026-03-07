import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

/// Horizontal filter bar letting users switch between All / Pending / Completed.
class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.chipBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusChip),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.format_list_bulleted_rounded,
            type: FilterType.all,
            active: provider.filter == FilterType.all,
          ),
          _FilterChip(
            label: 'Pending',
            icon: Icons.hourglass_empty_rounded,
            type: FilterType.pending,
            active: provider.filter == FilterType.pending,
          ),
          _FilterChip(
            label: 'Completed',
            icon: Icons.check_circle_outline_rounded,
            type: FilterType.completed,
            active: provider.filter == FilterType.completed,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.type,
    required this.active,
  });

  final String label;
  final IconData icon;
  final FilterType type;
  final bool active;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        // Highlight chip slightly on hover (web-friendly)
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.read<TaskProvider>().setFilter(widget.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.active
                  ? AppTheme.primary
                  : _hovering
                      ? AppTheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: widget.active
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 15,
                  color: widget.active
                      ? Colors.white
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight:
                        widget.active ? FontWeight.w700 : FontWeight.w500,
                    color: widget.active
                        ? Colors.white
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


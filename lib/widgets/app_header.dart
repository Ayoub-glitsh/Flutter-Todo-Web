import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

/// Dashboard-style header showing the app title and task counters.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 36, 32, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App title ──────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.checklist_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Tasks',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stay organised. Get things done.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Counter chips ───────────────────────────────────────────────
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatChip(
                    label: 'Total',
                    count: provider.totalCount,
                    icon: Icons.format_list_bulleted_rounded,
                    color: Colors.white,
                  ),
                  _StatChip(
                    label: 'Completed',
                    count: provider.completedCount,
                    icon: Icons.check_circle_rounded,
                    color: AppTheme.completed,
                  ),
                  _StatChip(
                    label: 'Pending',
                    count: provider.pendingCount,
                    icon: Icons.radio_button_unchecked_rounded,
                    color: AppTheme.accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small stat chip used in the header.
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusChip),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shown when the filtered/searched task list is empty.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.isSearching});

  /// True when the user has entered a search query (different message shown).
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative icon container
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.12),
                    AppTheme.primary.withValues(alpha: 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_rounded
                    : Icons.inbox_rounded,
                size: 44,
                color: AppTheme.primary.withValues(alpha: 0.5),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              isSearching ? 'No matching tasks' : 'No tasks yet',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try a different search term or clear the filter.'
                  : 'Tap the + button below to add your first task.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}


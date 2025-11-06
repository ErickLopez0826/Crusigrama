import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class HintSystemWidget extends ConsumerWidget {
  const HintSystemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(puzzleProvider);
    final hintsUsed = puzzle.hintsUsed;

    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hintsUsed > 0 
                ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: hintsUsed > 0 
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PISTAS: $hintsUsed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hintsUsed > 0 
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    letterSpacing: 1,
                  ),
                ),
                if (hintsUsed > 0) ...[
                  SizedBox(height: 2),
                  Text(
                    '-${hintsUsed * 50} pts',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}


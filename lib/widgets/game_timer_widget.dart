import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_stats.dart';
import '../providers.dart';
import '../utils.dart';

class GameTimerWidget extends ConsumerStatefulWidget {
  const GameTimerWidget({super.key});

  @override
  ConsumerState<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends ConsumerState<GameTimerWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (mounted) {
        setState(() {});
      }
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerNotifier = ref.watch(gameTimerProvider.notifier);
    final elapsed = timerNotifier.elapsed;
    final size = ref.watch(sizeProvider);
    final sizeKey = size.name;

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(
                  elapsed.formatted,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Consumer(
              builder: (context, ref, _) {
                final bestTimesAsync = ref.watch(bestTimesProvider);
                return bestTimesAsync.when(
                  data: (times) {
                    final bestTime = times[sizeKey] ?? 0;
                    if (bestTime > 0) {
                      return Text(
                        'Récord: ${Duration(seconds: bestTime).formatted}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                  loading: () => SizedBox.shrink(),
                  error: (_, __) => SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


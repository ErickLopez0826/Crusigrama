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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  elapsed.formatted,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
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
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    }
                    return Text(
                      'Sin récord previo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    );
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


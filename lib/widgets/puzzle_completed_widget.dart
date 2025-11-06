import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../game_stats.dart';
import '../providers.dart';
import '../utils.dart';

class PuzzleCompletedWidget extends ConsumerStatefulWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  ConsumerState<PuzzleCompletedWidget> createState() =>
      _PuzzleCompletedWidgetState();
}

class _PuzzleCompletedWidgetState
    extends ConsumerState<PuzzleCompletedWidget> {
  bool _scoresSaved = false;

  @override
  void initState() {
    super.initState();
    // Stop the timer, play victory sound and save scores
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final timer = ref.read(gameTimerProvider.notifier);
      timer.stop();
      
      // Play victory sound
      await ref.read(audioServiceProvider.notifier).playVictorySound();
      
      await _saveScoresIfNeeded();
    });
  }

  Future<void> _saveScoresIfNeeded() async {
    if (_scoresSaved) return;
    
    final timer = ref.read(gameTimerProvider.notifier);
    final puzzle = ref.read(puzzleProvider);
    final size = ref.read(sizeProvider);
    final elapsed = timer.elapsed;
    
    final score = puzzle.calculateScore(elapsed);
    final sizeKey = size.name;

    await ref.read(highScoresProvider.notifier).saveScore(sizeKey, score);
    await ref.read(bestTimesProvider.notifier).saveTime(sizeKey, elapsed.inSeconds);
    
    setState(() {
      _scoresSaved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = ref.watch(puzzleProvider);
    final timerNotifier = ref.watch(gameTimerProvider.notifier);
    final elapsed = timerNotifier.elapsed;
    final score = puzzle.calculateScore(elapsed);
    final size = ref.watch(sizeProvider);
    final sizeKey = size.name;

    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        margin: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'COMPLETADO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 32),
            _StatRow(
              icon: Icons.score,
              label: 'Puntuación',
              value: '$score puntos',
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 12),
            _StatRow(
              icon: Icons.timer,
              label: 'Tiempo',
              value: elapsed.formatted,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 12),
            _StatRow(
              icon: Icons.lightbulb,
              label: 'Pistas Usadas',
              value: '${puzzle.hintsUsed}',
              color: puzzle.hintsUsed > 0
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.tertiary,
            ),
            SizedBox(height: 12),
            _StatRow(
              icon: Icons.grid_on,
              label: 'Palabras',
              value: '${puzzle.crossword.words.length}',
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final highScoresAsync = ref.watch(highScoresProvider);
                final bestTimesAsync = ref.watch(bestTimesProvider);

                return Column(
                  children: [
                    highScoresAsync.when(
                      data: (scores) {
                        final record = scores[sizeKey] ?? 0;
                        final isNewRecord = score > record;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isNewRecord)
                              Icon(Icons.stars, color: Colors.amber, size: 20),
                            if (isNewRecord) SizedBox(width: 8),
                            Text(
                              isNewRecord
                                  ? '¡Nuevo Récord de Puntuación!'
                                  : 'Récord: $record puntos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isNewRecord ? FontWeight.bold : FontWeight.normal,
                                color: isNewRecord
                                    ? Colors.amber
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    ),
                    SizedBox(height: 8),
                    bestTimesAsync.when(
                      data: (times) {
                        final bestTime = times[sizeKey] ?? 0;
                        final isNewRecord = bestTime == 0 || elapsed.inSeconds < bestTime;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isNewRecord)
                              Icon(Icons.speed, color: Colors.green, size: 20),
                            if (isNewRecord) SizedBox(width: 8),
                            Text(
                              bestTime > 0
                                  ? (isNewRecord
                                      ? '¡Nuevo Récord de Tiempo!'
                                      : 'Mejor Tiempo: ${Duration(seconds: bestTime).formatted}')
                                  : '¡Primer Récord!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isNewRecord ? FontWeight.bold : FontWeight.normal,
                                color: isNewRecord
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Volver al menú principal
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: Icon(Icons.home, size: 18),
                  label: Text('MENÚ'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // Invalidar providers para regenerar el puzzle
                    ref.invalidate(workQueueProvider);
                    ref.invalidate(puzzleProvider);
                    ref.read(gameTimerProvider.notifier).reset();
                  },
                  icon: Icon(Icons.refresh, size: 18),
                  label: Text('NUEVO'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        SizedBox(width: 12),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}



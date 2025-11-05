import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../providers.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';

class CrosswordPuzzleApp extends ConsumerStatefulWidget {
  const CrosswordPuzzleApp({super.key});

  @override
  ConsumerState<CrosswordPuzzleApp> createState() => _CrosswordPuzzleAppState();
}

class _CrosswordPuzzleAppState extends ConsumerState<CrosswordPuzzleApp> {
  @override
  void initState() {
    super.initState();
    // Initialize audio and start background music (non-blocking)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider.future).then((_) {
        ref.read(audioServiceProvider.notifier).playBackgroundMusic();
      }).catchError((e) {
        debugPrint('Error initializing audio: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: [_CrosswordPuzzleAppMenu()],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: Text('Crossword Puzzle'),
        ),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzleSolved = ref.watch(
                puzzleProvider.select((puzzle) => puzzle.solved),
              );

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty) {
                    final puzzle = ref.watch(puzzleProvider);
                    // Show loading while puzzle is being created in isolate
                    if (puzzle.crossword.words.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Preparando Puzzle...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Generando palabras alternativas',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }
                    return CrosswordPuzzleWidget();
                  }
                  return CrosswordGeneratorWidget();
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

class _CrosswordPuzzleAppMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioServiceAsync = ref.watch(audioServiceProvider);
    
    return MenuAnchor(
      menuChildren: [
        for (final entry in CrosswordSize.values)
          MenuItemButton(
            onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
            leadingIcon: entry == ref.watch(sizeProvider)
                ? Icon(Icons.radio_button_checked_outlined)
                : Icon(Icons.radio_button_unchecked_outlined),
            child: Text(entry.label),
          ),
        Divider(),
        audioServiceAsync.when(
          data: (_) {
            final audioService = ref.read(audioServiceProvider.notifier);
            return MenuItemButton(
              leadingIcon: audioService.isMusicEnabled
                  ? Icon(Icons.music_note)
                  : Icon(Icons.music_off),
              onPressed: () => audioService.toggleMusic(),
              child: Text(audioService.isMusicEnabled ? 'Desactivar Música' : 'Activar Música'),
            );
          },
          loading: () => MenuItemButton(
            leadingIcon: Icon(Icons.music_note),
            onPressed: null,
            child: Text('Cargando Audio...'),
          ),
          error: (_, __) => SizedBox.shrink(),
        ),
        audioServiceAsync.when(
          data: (_) {
            final audioService = ref.read(audioServiceProvider.notifier);
            return MenuItemButton(
              leadingIcon: audioService.isSFXEnabled
                  ? Icon(Icons.volume_up)
                  : Icon(Icons.volume_off),
              onPressed: () => audioService.toggleSFX(),
              child: Text(audioService.isSFXEnabled ? 'Desactivar Efectos' : 'Activar Efectos'),
            );
          },
          loading: () => MenuItemButton(
            leadingIcon: Icon(Icons.volume_up),
            onPressed: null,
            child: Text('Cargando...'),
          ),
          error: (_, __) => SizedBox.shrink(),
        ),
      ],
      builder: (context, controller, child) => IconButton(
        onPressed: () => controller.open(),
        icon: Icon(Icons.settings),
      ),
    );
  }
}


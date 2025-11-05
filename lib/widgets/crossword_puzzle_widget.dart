import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../audio_service.dart';
import '../game_stats.dart';
import '../model.dart';
import '../providers.dart';
import 'game_timer_widget.dart';
import 'hint_system_widget.dart';

class CrosswordPuzzleWidget extends ConsumerWidget {
  const CrosswordPuzzleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    
    // Start timer when puzzle is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = ref.read(gameTimerProvider.notifier);
      if (!timer.isRunning) {
        timer.start();
      }
    });

    return Stack(
      children: [
        TableView.builder(
          diagonalDragBehavior: DiagonalDragBehavior.free,
          cellBuilder: _buildCell,
          columnCount: size.width,
          columnBuilder: (index) => _buildSpan(context, index),
          rowCount: size.height,
          rowBuilder: (index) => _buildSpan(context, index),
        ),
        GameTimerWidget(),
        HintSystemWidget(),
      ],
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Consumer(
        builder: (context, ref, _) {
          final character = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.crossword.characters[location],
            ),
          );
          final selectedCharacter = ref.watch(
            puzzleProvider.select(
              (puzzle) =>
                  puzzle.crosswordFromSelectedWords.characters[location],
            ),
          );
          final alternateWords = ref.watch(
            puzzleProvider.select((puzzle) => puzzle.alternateWords),
          );
          final isRevealed = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.revealedLocations.contains(location),
            ),
          );

          if (character != null) {
            final acrossWord = character.acrossWord;
            var acrossWords = BuiltList<String>();
            if (acrossWord != null) {
              final alternates = alternateWords[acrossWord.location]?[acrossWord.direction] ?? BuiltList<String>();
              acrossWords = acrossWords.rebuild(
                (b) => b
                  ..add(acrossWord.word)
                  ..addAll(alternates)
                  ..sort(),
              );
            }

            final downWord = character.downWord;
            var downWords = BuiltList<String>();
            if (downWord != null) {
              final alternates = alternateWords[downWord.location]?[downWord.direction] ?? BuiltList<String>();
              downWords = downWords.rebuild(
                (b) => b
                  ..add(downWord.word)
                  ..addAll(alternates)
                  ..sort(),
              );
            }

            return MenuAnchor(
              builder: (context, controller, _) {
                return GestureDetector(
                  onTapDown: (details) =>
                      controller.open(position: details.localPosition),
                  child: AnimatedContainer(
                    duration: Durations.extralong1,
                    curve: Curves.easeInOut,
                    color: isRevealed
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.onPrimary,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: Durations.extralong1,
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 24,
                          color: isRevealed
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: isRevealed ? FontWeight.bold : FontWeight.normal,
                        ),
                        child: Text(
                          isRevealed
                              ? character.character
                              : (selectedCharacter?.character ?? ''),
                        ),
                      ),
                    ),
                  ),
                );
              },
              menuChildren: [
                if (acrossWords.isNotEmpty || downWords.isNotEmpty)
                  MenuItemButton(
                    leadingIcon: Icon(Icons.lightbulb_outline, size: 20),
                    onPressed: () {
                      // Capturar referencias antes de cualquier operación asíncrona
                      final audioService = ref.read(audioServiceProvider.notifier);
                      final puzzleNotifier = ref.read(puzzleProvider.notifier);
                      
                      // Revelar palabra inmediatamente
                      if (acrossWords.isNotEmpty) {
                        puzzleNotifier.revealWordHint(
                          location: acrossWord!.location,
                          direction: Direction.across,
                        );
                      } else if (downWords.isNotEmpty) {
                        puzzleNotifier.revealWordHint(
                          location: downWord!.location,
                          direction: Direction.down,
                        );
                      }
                      
                      // Reproducir sonido después (sin await)
                      audioService.playHintSound();
                    },
                    child: Text('Revelar Palabra (-50 pts)'),
                  ),
                if (acrossWords.isNotEmpty || downWords.isNotEmpty)
                  Divider(),
                if (acrossWords.isNotEmpty && downWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Across'),
                  ),
                for (final word in acrossWords)
                  _WordSelectMenuItem(
                    location: acrossWord!.location,
                    word: word,
                    selectedCharacter: selectedCharacter,
                    direction: Direction.across,
                  ),
                if (acrossWords.isNotEmpty && downWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Down'),
                  ),
                for (final word in downWords)
                  _WordSelectMenuItem(
                    location: downWord!.location,
                    word: word,
                    selectedCharacter: selectedCharacter,
                    direction: Direction.down,
                  ),
              ],
            );
          }

          return ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
          );
        },
      ),
    );
  }

  TableSpan _buildSpan(BuildContext context, int index) {
    return TableSpan(
      extent: FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          trailing: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _WordSelectMenuItem extends ConsumerWidget {
  const _WordSelectMenuItem({
    required this.location,
    required this.word,
    required this.selectedCharacter,
    required this.direction,
  });

  final Location location;
  final String word;
  final CrosswordCharacter? selectedCharacter;
  final Direction direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(puzzleProvider.notifier);
    final canSelect = ref.watch(
      puzzleProvider.select(
        (puzzle) => puzzle.canSelectWord(
          location: location,
          word: word,
          direction: direction,
        ),
      ),
    );
    
    return MenuItemButton(
      onPressed: canSelect
          ? () {
              // Capturar referencias antes de cualquier operación asíncrona
              final audioService = ref.read(audioServiceProvider.notifier);
              
              // Seleccionar palabra inmediatamente
              notifier.selectWord(
                location: location,
                word: word,
                direction: direction,
              );
              
              // Reproducir sonido después (sin await para evitar que el widget se destruya)
              audioService.playSelectionSound();
            }
          : null,
      leadingIcon:
          switch (direction) {
            Direction.across => selectedCharacter?.acrossWord?.word == word,
            Direction.down => selectedCharacter?.downWord?.word == word,
          }
          ? Icon(Icons.radio_button_checked_outlined)
          : Icon(Icons.radio_button_unchecked_outlined),
      child: Text(word),
    );
  }
}


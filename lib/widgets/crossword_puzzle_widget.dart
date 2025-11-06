import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../audio_service.dart';
import '../crossword_input_state.dart';
import '../game_stats.dart';
import '../model.dart';
import '../providers.dart';
import 'game_timer_widget.dart';
import 'hint_system_widget.dart';

class CrosswordPuzzleWidget extends ConsumerStatefulWidget {
  const CrosswordPuzzleWidget({super.key});

  @override
  ConsumerState<CrosswordPuzzleWidget> createState() => _CrosswordPuzzleWidgetState();
}

class _CrosswordPuzzleWidgetState extends ConsumerState<CrosswordPuzzleWidget> {
  @override
  void initState() {
    super.initState();
    // Iniciar timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = ref.read(gameTimerProvider.notifier);
      if (!timer.isRunning) {
        timer.start();
      }
    });
  }

  void _submitWord(Location location, String word, Direction direction) {
    final puzzleNotifier = ref.read(puzzleProvider.notifier);
    final audioService = ref.read(audioServiceProvider.notifier);
    
    puzzleNotifier.selectWord(
      location: location,
      word: word,
      direction: direction,
    );
    
    audioService.playSelectionSound();
  }

  void _showHintDialog() {
    final inputState = ref.read(crosswordInputProvider);
    if (inputState.selectedCell == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una celda primero'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final puzzle = ref.read(puzzleProvider);
    final character = puzzle.crossword.characters[inputState.selectedCell!];
    if (character == null) return;

    final acrossWord = character.acrossWord;
    final downWord = character.downWord;
    
    if (acrossWord == null && downWord == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'REVELAR PALABRA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (acrossWord != null)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(puzzleProvider.notifier).revealWordHint(
                    location: acrossWord.location,
                    direction: Direction.across,
                  );
                  ref.read(audioServiceProvider.notifier).playHintSound();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Horizontal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${acrossWord.word.length} letras • -50 pts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (acrossWord != null && downWord != null)
              SizedBox(height: 12),
            if (downWord != null)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(puzzleProvider.notifier).revealWordHint(
                    location: downWord.location,
                    direction: Direction.down,
                  );
                  ref.read(audioServiceProvider.notifier).playHintSound();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vertical',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${downWord.word.length} letras • -50 pts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCELAR',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInputDialog() {
    final inputState = ref.read(crosswordInputProvider);
    if (inputState.selectedCell == null) return;

    final puzzle = ref.read(puzzleProvider);
    final character = puzzle.crossword.characters[inputState.selectedCell!];
    if (character == null) return;

    final currentWord = inputState.direction == Direction.across
        ? character.acrossWord
        : character.downWord;

    if (currentWord == null) return;

    final textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ingresar Palabra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${currentWord.word.length} letras',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              autofocus: true,
              maxLength: currentWord.word.length,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                counterText: '',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.length == currentWord.word.length) {
                  Navigator.pop(context);
                  _submitWord(currentWord.location, value.toLowerCase(), currentWord.direction);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final text = textController.text.toLowerCase();
              if (text.length == currentWord.word.length) {
                Navigator.pop(context);
                _submitWord(currentWord.location, text, currentWord.direction);
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = ref.watch(sizeProvider);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              TableView.builder(
                diagonalDragBehavior: DiagonalDragBehavior.free,
                cellBuilder: _buildCell,
                columnCount: size.width,
                columnBuilder: (index) => _buildSpan(context, index),
                rowCount: size.height,
                rowBuilder: (index) => _buildSpan(context, index),
              ),
              const GameTimerWidget(),
              const HintSystemWidget(),
        // Botón de pistas
        Positioned(
          top: 70,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showHintDialog,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
              // Botón para escribir (móvil)
              Positioned(
                bottom: 16,
                right: 16,
                child: Consumer(
                  builder: (context, ref, _) {
                    final inputState = ref.watch(crosswordInputProvider);
                    if (inputState.selectedCell == null) return const SizedBox.shrink();
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showInputDialog,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.keyboard,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Widget de pistas en la parte inferior
        Consumer(
          builder: (context, ref, _) {
            final inputState = ref.watch(crosswordInputProvider);
            if (inputState.selectedCell == null) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  'Selecciona una casilla para ver la pista',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final puzzle = ref.watch(puzzleProvider);
            final character = puzzle.crossword.characters[inputState.selectedCell!];
            
            if (character == null) {
              return const SizedBox.shrink();
            }

            final currentWord = inputState.direction == Direction.across
                ? character.acrossWord
                : character.downWord;

            if (currentWord == null) {
              return const SizedBox.shrink();
            }

            final hint = currentWord.hint ?? 'Sin pista disponible';
            final directionText = inputState.direction == Direction.across ? 'Horizontal' : 'Vertical';
            
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          inputState.direction == Direction.across
                              ? Icons.arrow_forward
                              : Icons.arrow_downward,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$directionText',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${currentWord.word.length} letras',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hint,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
          
          final isRevealed = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.revealedLocations.contains(location),
            ),
          );

          final inputState = ref.watch(crosswordInputProvider);
          final isSelected = inputState.selectedCell == location;

          if (character != null) {
            // Determinar qué carácter mostrar
            String displayChar = '';
            if (isRevealed) {
              displayChar = character.character;
            } else {
              displayChar = selectedCharacter?.character ?? '';
            }

            return GestureDetector(
              onTap: () {
                final inputNotifier = ref.read(crosswordInputProvider.notifier);
                
                if (isSelected) {
                  // Si ya está seleccionada, cambiar dirección
                  inputNotifier.toggleDirection();
                } else {
                  // Seleccionar esta celda
                  inputNotifier.selectCell(location);
                }
              },
              child: AnimatedContainer(
                duration: Durations.medium1,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isRevealed
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.onPrimary,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Durations.medium1,
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 24,
                      color: isRevealed
                          ? Theme.of(context).colorScheme.tertiary
                          : isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary,
                      fontWeight: isRevealed || isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    child: Text(displayChar.toUpperCase()),
                  ),
                ),
              ),
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
      extent: const FixedTableSpanExtent(32),
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

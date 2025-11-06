import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isolates.dart';
import 'model.dart' as model;

part 'providers.g.dart';

const backgroundWorkerCount = 4;

/// A provider for the hints/clues for each word.
@riverpod
Future<Map<String, String>> wordHints(ref) async {
  try {
    final hintsJson = await rootBundle.loadString('assets/hints.json');
    final hintsData = json.decode(hintsJson) as Map<String, dynamic>;
    return hintsData.map((key, value) => MapEntry(key, value.toString()));
  } catch (e) {
    debugPrint('Error loading hints: $e');
    return {};
  }
}

/// A provider for the wordlist to use when generating the crossword.
@riverpod
Future<BuiltSet<String>> wordList(ref) async {
  // This codebase requires that all words consist of lowercase characters
  // in the range 'a'-'z'. Words containing uppercase letters will be
  // lowercased, and words containing runes outside this range will
  // be removed.

  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');
  return const LineSplitter()
      .convert(words)
      .toBuiltSet()
      .rebuild(
        (b) => b
          ..map((word) => word.toLowerCase().trim())
          ..where((word) => word.length > 2)
          ..where((word) => re.hasMatch(word)),
      );
}

/// An enumeration for different sizes of [model.Crossword]s.
enum CrosswordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrosswordSize({required this.width, required this.height});

  final int width;
  final int height;
  String get label => '$width x $height';
}

/// A provider that holds the current size of the crossword to generate.
@Riverpod(keepAlive: true)
class Size extends _$Size {
  var _size = CrosswordSize.medium;

  @override
  CrosswordSize build() => _size;

  void setSize(CrosswordSize size) {
    _size = size;
    ref.invalidateSelf();
  }
}

@riverpod
Stream<model.WorkQueue> workQueue(ref) async* {
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(wordListProvider);
  final emptyCrossword = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );
  final emptyWorkQueue = model.WorkQueue.from(
    crossword: emptyCrossword,
    candidateWords: BuiltSet<String>(),
    startLocation: model.Location.at(0, 0),
  );

  // Check if data is available using pattern matching
  if (wordListAsync is AsyncData<BuiltSet<String>>) {
    final wordList = wordListAsync.value;
    yield* exploreCrosswordSolutions(
      crossword: emptyCrossword,
      wordList: wordList,
      maxWorkerCount: backgroundWorkerCount,
    );
  } else if (wordListAsync is AsyncError) {
    debugPrint('Error loading word list: ${wordListAsync.error}');
    yield emptyWorkQueue;
  } else {
    // Loading state
    yield emptyWorkQueue;
  }
}

@Riverpod(keepAlive: true)
class Puzzle extends _$Puzzle {
  model.CrosswordPuzzleGame _currentPuzzle = model.CrosswordPuzzleGame.from(
    crossword: model.Crossword.crossword(width: 0, height: 0),
    candidateWords: BuiltSet<String>(),
  );
  bool _isGenerating = false;

  @override
  model.CrosswordPuzzleGame build() {
    // Get values safely using pattern matching
    final wordListAsync = ref.watch(wordListProvider);
    final workQueueAsync = ref.watch(workQueueProvider);
    final hintsAsync = ref.watch(wordHintsProvider);

    // Extract values only if they're available using type checking
    BuiltSet<String>? wordList;
    model.WorkQueue? workQueue;
    Map<String, String>? hints;

    if (wordListAsync is AsyncData<BuiltSet<String>>) {
      wordList = wordListAsync.value;
    }

    if (workQueueAsync is AsyncData<model.WorkQueue>) {
      workQueue = workQueueAsync.value;
    }

    if (hintsAsync is AsyncData<Map<String, String>>) {
      hints = hintsAsync.value;
    }

    if (wordList == null || workQueue == null || !workQueue.isCompleted || hints == null) {
      return _currentPuzzle;
    }

    // Only create puzzle once and asynchronously
    if (_currentPuzzle.crossword.words.isEmpty && 
        workQueue.crossword.words.isNotEmpty &&
        !_isGenerating) {
      _isGenerating = true;
      debugPrint('🎮 Starting puzzle creation: ${workQueue.crossword.words.length} words');
      
      compute(_createPuzzleInIsolate, (
        workQueue.crossword,
        wordList,
        hints,
      )).then((puzzle) {
        debugPrint('✅ Puzzle created successfully with ${puzzle.alternateWords.length} locations');
        _currentPuzzle = puzzle;
        _isGenerating = false;
        ref.invalidateSelf();
      }).catchError((e) {
        debugPrint('❌ Error creating puzzle: $e');
        _isGenerating = false;
      });
    }

    return _currentPuzzle;
  }

  void selectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) {
    final currentPuzzle = state;
    debugPrint('🎯 Intentando seleccionar: $word en ${location.prettyPrint()} dirección: $direction');
    debugPrint('   Estado actual: ${currentPuzzle.selectedWords.length} palabras seleccionadas');
    
    final candidate = currentPuzzle.selectWord(
      location: location,
      word: word,
      direction: direction,
    );

    if (candidate != null) {
      debugPrint('✅ Palabra seleccionada: $word (${candidate.selectedWords.length}/${currentPuzzle.crossword.words.length})');
      debugPrint('   Palabras seleccionadas: ${candidate.selectedWords.map((w) => w.word).join(", ")}');
      debugPrint('   Caracteres en crosswordFromSelectedWords: ${candidate.crosswordFromSelectedWords.characters.length}');
      
      // Actualizar estado ANTES de verificar
      state = candidate;
      
      // Verificar que el estado se actualizó
      debugPrint('   Estado después de actualización: ${state.selectedWords.length} palabras');
      debugPrint('   Caracteres después: ${state.crosswordFromSelectedWords.characters.length}');
      
      // Forzar notificación a los listeners
      ref.notifyListeners();
    } else {
      debugPrint('❌ Selección inválida: $word en ${location.prettyPrint()}');
      debugPrint('   Palabra correcta: ${currentPuzzle.crossword.words.where((w) => w.location == location && w.direction == direction).map((w) => w.word).join(", ")}');
      debugPrint('   Palabras alternas disponibles: ${currentPuzzle.alternateWords[location]?[direction]?.join(", ") ?? "ninguna"}');
    }
  }

  bool canSelectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) {
    return state.canSelectWord(
      location: location,
      word: word,
      direction: direction,
    );
  }

  void revealHint(model.Location location) {
    state = state.revealHint(location);
  }

  void revealWordHint({
    required model.Location location,
    required model.Direction direction,
  }) {
    final character = state.crossword.characters[location];
    if (character == null) return;

    final word = direction == model.Direction.across
        ? character.acrossWord
        : character.downWord;

    if (word != null) {
      final candidate = state.selectWord(
        location: word.location,
        word: word.word,
        direction: word.direction,
      );

      if (candidate != null) {
        state = candidate.revealHint(location);
      }
    }
  }
}

// Trampoline function to create puzzle in isolate (prevents ANR)
model.CrosswordPuzzleGame _createPuzzleInIsolate(
  (model.Crossword, BuiltSet<String>, Map<String, String>) args,
) {
  // Add hints to the crossword
  final crosswordWithHints = args.$1.addHints(args.$3);
  
  final puzzle = model.CrosswordPuzzleGame.from(
    crossword: crosswordWithHints,
    candidateWords: args.$2,
  );
  return puzzle;
}


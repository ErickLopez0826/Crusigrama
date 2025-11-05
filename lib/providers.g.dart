// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordHintsHash() => r'6aa0895410b82f4caf4489125da069f312865e0d';

/// A provider for the hints/clues for each word.
///
/// Copied from [wordHints].
@ProviderFor(wordHints)
final wordHintsProvider =
    AutoDisposeFutureProvider<Map<String, String>>.internal(
      wordHints,
      name: r'wordHintsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wordHintsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordHintsRef = AutoDisposeFutureProviderRef<Map<String, String>>;
String _$wordListHash() => r'8e3e9cd4555ba4baa045ccddd8dd45a25cfb6653';

/// A provider for the wordlist to use when generating the crossword.
///
/// Copied from [wordList].
@ProviderFor(wordList)
final wordListProvider = AutoDisposeFutureProvider<BuiltSet<String>>.internal(
  wordList,
  name: r'wordListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$workQueueHash() => r'f7af7a45cf9151794c25ebfc87233f6275898214';

/// See also [workQueue].
@ProviderFor(workQueue)
final workQueueProvider = AutoDisposeStreamProvider<model.WorkQueue>.internal(
  workQueue,
  name: r'workQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkQueueRef = AutoDisposeStreamProviderRef<model.WorkQueue>;
String _$sizeHash() => r'e551985965bf4119e8d90c0e8aa4f4d68a555b73';

/// A provider that holds the current size of the crossword to generate.
///
/// Copied from [Size].
@ProviderFor(Size)
final sizeProvider = NotifierProvider<Size, CrosswordSize>.internal(
  Size.new,
  name: r'sizeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Size = Notifier<CrosswordSize>;
String _$puzzleHash() => r'21c67b3e10ac2c26a3843516345daf449c294142';

/// See also [Puzzle].
@ProviderFor(Puzzle)
final puzzleProvider =
    NotifierProvider<Puzzle, model.CrosswordPuzzleGame>.internal(
      Puzzle.new,
      name: r'puzzleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$puzzleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Puzzle = Notifier<model.CrosswordPuzzleGame>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

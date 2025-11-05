// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameTimerHash() => r'64af73db46b2b75ac00f2bf124c262e1dec70929';

/// Provider for game timer
///
/// Copied from [GameTimer].
@ProviderFor(GameTimer)
final gameTimerProvider = NotifierProvider<GameTimer, Duration>.internal(
  GameTimer.new,
  name: r'gameTimerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameTimerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameTimer = Notifier<Duration>;
String _$highScoresHash() => r'7caf52e743a66efc12fef62f34bbe100fc07ea9c';

/// Provider for managing high scores and records
///
/// Copied from [HighScores].
@ProviderFor(HighScores)
final highScoresProvider =
    AutoDisposeAsyncNotifierProvider<HighScores, Map<String, int>>.internal(
      HighScores.new,
      name: r'highScoresProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$highScoresHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HighScores = AutoDisposeAsyncNotifier<Map<String, int>>;
String _$bestTimesHash() => r'28b5ef9e87c1c0b571d9f79573e7399bec185b5a';

/// Provider for best times per size
///
/// Copied from [BestTimes].
@ProviderFor(BestTimes)
final bestTimesProvider =
    AutoDisposeAsyncNotifierProvider<BestTimes, Map<String, int>>.internal(
      BestTimes.new,
      name: r'bestTimesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bestTimesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BestTimes = AutoDisposeAsyncNotifier<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

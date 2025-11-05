import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'game_stats.g.dart';

/// Provider for game timer
@Riverpod(keepAlive: true)
class GameTimer extends _$GameTimer {
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  Duration build() => Duration.zero;

  void start() {
    _startTime = DateTime.now();
    _endTime = null;
    ref.invalidateSelf();
  }

  void stop() {
    if (_startTime != null) {
      _endTime = DateTime.now();
      ref.invalidateSelf();
    }
  }

  void reset() {
    _startTime = null;
    _endTime = null;
    ref.invalidateSelf();
  }

  Duration get elapsed {
    if (_startTime == null) return Duration.zero;
    final end = _endTime ?? DateTime.now();
    return end.difference(_startTime!);
  }

  bool get isRunning => _startTime != null && _endTime == null;
}

/// Provider for managing high scores and records
@riverpod
class HighScores extends _$HighScores {
  @override
  Future<Map<String, int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'small': prefs.getInt('record_small') ?? 0,
      'medium': prefs.getInt('record_medium') ?? 0,
      'large': prefs.getInt('record_large') ?? 0,
      'xlarge': prefs.getInt('record_xlarge') ?? 0,
      'xxlarge': prefs.getInt('record_xxlarge') ?? 0,
    };
  }

  Future<void> saveScore(String sizeKey, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentRecord = prefs.getInt('record_$sizeKey') ?? 0;
    
    if (score > currentRecord) {
      await prefs.setInt('record_$sizeKey', score);
      ref.invalidateSelf();
    }
  }

  Future<int> getRecordForSize(String sizeKey) async {
    final scores = await future;
    return scores[sizeKey] ?? 0;
  }
}

/// Provider for best times per size
@riverpod
class BestTimes extends _$BestTimes {
  @override
  Future<Map<String, int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'small': prefs.getInt('time_small') ?? 0,
      'medium': prefs.getInt('time_medium') ?? 0,
      'large': prefs.getInt('time_large') ?? 0,
      'xlarge': prefs.getInt('time_xlarge') ?? 0,
      'xxlarge': prefs.getInt('time_xxlarge') ?? 0,
    };
  }

  Future<void> saveTime(String sizeKey, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = prefs.getInt('time_$sizeKey') ?? 0;
    
    if (currentBest == 0 || seconds < currentBest) {
      await prefs.setInt('time_$sizeKey', seconds);
      ref.invalidateSelf();
    }
  }

  Future<int> getBestTimeForSize(String sizeKey) async {
    final times = await future;
    return times[sizeKey] ?? 0;
  }
}


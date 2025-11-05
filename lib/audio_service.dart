import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service.g.dart';

/// Audio service for managing all game sounds
@Riverpod(keepAlive: true)
class AudioService extends _$AudioService {
  SoLoud? _soloud;
  AudioSource? _backgroundMusicSource;
  SoundHandle? _backgroundMusicHandle;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;

  @override
  Future<bool> build() async {
    try {
      _soloud = SoLoud.instance;
      await _soloud!.init();
      debugPrint('Audio initialized successfully');
      
      // Generate background music
      await _generateBackgroundMusic();
      
      return true;
    } catch (e) {
      debugPrint('Error initializing audio: $e');
      return false;
    }
  }

  Future<void> _generateBackgroundMusic() async {
    if (_soloud == null) return;

    try {
      // Load the looped background music
      _backgroundMusicSource = await _soloud!.loadAsset('assets/music/audio_soloud_step_06_assets_music_looped-song.ogg');
      debugPrint('Background music loaded successfully');
    } catch (e) {
      debugPrint('Error loading background music: $e');
      // Try procedural generation as fallback
      try {
        _backgroundMusicSource = await _soloud!.loadWaveform(
          WaveForm.square,
          true, // superWave
          0.5, // scale
          0.5, // detune
        );
        debugPrint('Using procedural background music');
      } catch (e2) {
        debugPrint('Error generating background music: $e2');
      }
    }
  }

  /// Play background music
  Future<void> playBackgroundMusic() async {
    if (_soloud == null || !_musicEnabled) return;

    try {
      if (_backgroundMusicSource != null && 
          (_backgroundMusicHandle == null || !_soloud!.getIsValidVoiceHandle(_backgroundMusicHandle!))) {
        _backgroundMusicHandle = await _soloud!.play(
          _backgroundMusicSource!,
          volume: 0.3,
          looping: true,
        );
        debugPrint('Background music started');
      }
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    if (_soloud == null || _backgroundMusicHandle == null) return;
    
    try {
      if (_soloud!.getIsValidVoiceHandle(_backgroundMusicHandle!)) {
        await _soloud!.stop(_backgroundMusicHandle!);
        _backgroundMusicHandle = null;
        debugPrint('Background music stopped');
      }
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  /// Play victory sound
  Future<void> playVictorySound() async {
    if (_soloud == null || !_sfxEnabled) return;

    try {
      // Load the orchestral victory sound
      final source = await _soloud!.loadAsset('assets/sounds/orchestral-win-331233.mp3');
      await _soloud!.play(source, volume: 0.6);
      debugPrint('Victory sound played');
    } catch (e) {
      debugPrint('Error playing victory sound: $e');
      // Fallback to procedural sound
      try {
        final source = await _soloud!.loadWaveform(
          WaveForm.saw,
          true, // superWave
          1.0, // scale
          0.5, // detune
        );
        for (var i = 0; i < 4; i++) {
          await _soloud!.play(source, volume: 0.5);
          await Future.delayed(Duration(milliseconds: 100));
        }
      } catch (e2) {
        debugPrint('Error with fallback victory sound: $e2');
      }
    }
  }

  /// Play defeat/game over sound
  Future<void> playDefeatSound() async {
    if (_soloud == null || !_sfxEnabled) return;

    try {
      // Load the game over sound
      final source = await _soloud!.loadAsset('assets/sounds/game-over-38511.mp3');
      await _soloud!.play(source, volume: 0.5);
      debugPrint('Defeat sound played');
    } catch (e) {
      debugPrint('Error playing defeat sound: $e');
    }
  }

  /// Play selection sound (when selecting a word)
  Future<void> playSelectionSound() async {
    if (_soloud == null || !_sfxEnabled) return;

    try {
      AudioSource? source;
      try {
        source = await _soloud!.loadAsset('assets/sounds/selection.wav');
      } catch (e) {
        source = await _soloud!.loadWaveform(
          WaveForm.square,
          false, // superWave
          0.5, // scale
          0.1, // detune
        );
      }
      
      await _soloud!.play(source, volume: 0.3);
    } catch (e) {
      debugPrint('Error playing selection sound: $e');
    }
  }

  /// Play hint reveal sound
  Future<void> playHintSound() async {
    if (_soloud == null || !_sfxEnabled) return;

    try {
      AudioSource? source;
      try {
        source = await _soloud!.loadAsset('assets/sounds/hint.wav');
      } catch (e) {
        source = await _soloud!.loadWaveform(
          WaveForm.triangle,
          false, // superWave
          0.8, // scale
          0.3, // detune
        );
      }
      
      await _soloud!.play(source, volume: 0.4);
    } catch (e) {
      debugPrint('Error playing hint sound: $e');
    }
  }

  /// Play error sound (invalid selection)
  Future<void> playErrorSound() async {
    if (_soloud == null || !_sfxEnabled) return;

    try {
      AudioSource? source;
      try {
        source = await _soloud!.loadAsset('assets/sounds/error.wav');
      } catch (e) {
        source = await _soloud!.loadWaveform(
          WaveForm.saw,
          false, // superWave
          0.3, // scale
          1.0, // detune
        );
      }
      
      await _soloud!.play(source, volume: 0.3);
    } catch (e) {
      debugPrint('Error playing error sound: $e');
    }
  }

  /// Toggle background music on/off
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (_musicEnabled) {
      playBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
    ref.invalidateSelf();
  }

  /// Toggle sound effects on/off
  void toggleSFX() {
    _sfxEnabled = !_sfxEnabled;
    ref.invalidateSelf();
  }

  bool get isMusicEnabled => _musicEnabled;
  bool get isSFXEnabled => _sfxEnabled;

  /// Dispose audio resources
  Future<void> dispose() async {
    await stopBackgroundMusic();
    _soloud?.deinit();
    debugPrint('Audio service disposed');
  }
}


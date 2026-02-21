import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../app_design/app_audio.dart';
import '../app_logger.dart';

class SfxPlayer {
  SfxPlayer() {
    unawaited(_ensurePoolsReady());
  }

  Future<void>? _poolsFuture;
  AudioPool? _encounteredEnemyPool;
  AudioPool? _encounteredTargetPool;
  AudioPool? _showingScoresPool;
  bool _soundEnabled = true;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playEncounteredEnemy() async {
    await _play(_encounteredEnemyPool);
  }

  Future<void> playEncounteredTarget() async {
    await _play(_encounteredTargetPool);
  }

  Future<void> playShowingScores() async {
    await _play(_showingScoresPool);
  }

  Future<void> _play(AudioPool? pool) async {
    if (!_soundEnabled) {
      return;
    }

    try {
      await _ensurePoolsReady();
      if (pool == null) {
        return;
      }

      await pool.start(volume: AppAudio.sfxVolume);
    } catch (error, stackTrace) {
      appLogger.severe('Failed to play sfx', error, stackTrace);
    }
  }

  Future<void> _ensurePoolsReady() {
    return _poolsFuture ??= _createPools();
  }

  Future<void> _createPools() async {
    final sfxContext = AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build();

    _encounteredEnemyPool = await AudioPool.create(
      source: AssetSource('audio/encountered_enemy.mp3'),
      maxPlayers: 2,
      minPlayers: 1,
      audioContext: sfxContext,
    );
    _encounteredTargetPool = await AudioPool.create(
      source: AssetSource('audio/encountered_target.mp3'),
      maxPlayers: 3,
      minPlayers: 1,
      audioContext: sfxContext,
    );
    _showingScoresPool = await AudioPool.create(
      source: AssetSource('audio/showing_scores.mp3'),
      maxPlayers: 1,
      minPlayers: 1,
      audioContext: sfxContext,
    );
  }

  Future<void> dispose() async {
    await _encounteredEnemyPool?.dispose();
    await _encounteredTargetPool?.dispose();
    await _showingScoresPool?.dispose();
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_durations.dart';
import '../../models/level_type.dart';
import '../../services/audio_service/audio_service.dart';
import '../../services/app_logger.dart';

part 'level_event.dart';
part 'level_state.dart';
part 'level_logic/level_ball_logic.dart';
part 'level_logic/level_enemy_logic.dart';
part 'level_logic/level_tick_coordinator.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc({required AudioService audioService, bool enableTicker = true})
    : _audioService = audioService,
      _ballLogic = _LevelBallLogic(),
      _enemyLogic = _LevelEnemyLogic(),
      super(LevelState.initial()) {
    _tickCoordinator = _LevelTickCoordinator(
      ballLogic: _ballLogic,
      enemyLogic: _enemyLogic,
    );
    on<LevelStartRequested>(_onStartRequested);
    on<LevelTicked>(_onTicked);
    on<LevelGyroUpdated>(_onGyroUpdated);
    on<LevelViewportChanged>(_onViewportChanged);
    on<LevelResetToMenuRequested>(_onReset);

    _accelerometerSubscription = accelerometerEventStream().listen(
      (event) => add(LevelGyroUpdated(x: event.x, y: event.y)),
      onError: (Object error, StackTrace stackTrace) {
        appLogger.severe('Accelerometer stream error', error, stackTrace);
      },
    );

    if (enableTicker) {
      _ticker = Timer.periodic(
        AppDurations.tick,
        (_) => add(const LevelTicked(0.016)),
      );
    }
  }

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _ticker;
  final AudioService _audioService;
  final _LevelBallLogic _ballLogic;
  final _LevelEnemyLogic _enemyLogic;
  late final _LevelTickCoordinator _tickCoordinator;
  double _tiltX = 0;
  double _tiltY = 0;

  Future<void> _onStartRequested(
    LevelStartRequested event,
    Emitter<LevelState> emit,
  ) async {
    final viewport = state.viewport;
    final center = viewport == Size.zero
        ? const Offset(200, 300)
        : Offset(viewport.width / 2, viewport.height / 2);
    emit(
      state.copyWith(
        status: LevelStatus.playing,
        levelType: event.levelType,
        playerName: event.playerName,
        points: 0,
        lives: 3,
        timeLeft: Duration.zero,
        totalDuration: Duration.zero,
        elapsed: Duration.zero,
        ballCenter: center,
        ballVelocity: _LevelBallLogic.initialVelocity,
        leftEnemyAxis: 0.3,
        rightEnemyAxis: 0.7,
        bottomEnemyAxis: 0.5,
        targetAxis: 0.5,
        targetDirection: 1,
        lowerTargetAxis: 0.5,
        lowerTargetDirection: 1,
        enemyDirection: 1,
        finishedAt: null,
        errorMessage: null,
        spawnedEnemyBatches: 0,
        dynamicEnemies: const [],
      ),
    );
  }

  void _onGyroUpdated(LevelGyroUpdated event, Emitter<LevelState> emit) {
    _tiltX = event.x;
    _tiltY = event.y;
  }

  void _onViewportChanged(
    LevelViewportChanged event,
    Emitter<LevelState> emit,
  ) {
    final viewport = event.size;
    if (viewport == Size.zero) {
      return;
    }
    final center = Offset(viewport.width / 2, viewport.height / 2);
    emit(state.copyWith(viewport: viewport, ballCenter: center));
  }

  void _onTicked(LevelTicked event, Emitter<LevelState> emit) {
    try {
      final outcome = _tickCoordinator.coordinate(
        state: state,
        dt: event.deltaSeconds,
        tiltX: _tiltX,
        tiltY: _tiltY,
        now: DateTime.now(),
      );

      if (outcome.playShowingScores) {
        unawaited(_audioService.playShowingScores());
      }
      if (outcome.playEncounteredTarget) {
        unawaited(_audioService.playEncounteredTarget());
      }
      if (outcome.playEncounteredEnemy) {
        unawaited(_audioService.playEncounteredEnemy());
      }

      if (outcome.nextState != null) {
        emit(outcome.nextState!);
      }
    } catch (error, stackTrace) {
      appLogger.severe('Level tick failed', error, stackTrace);
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  void _onReset(LevelResetToMenuRequested event, Emitter<LevelState> emit) {
    emit(LevelState.initial().copyWith(viewport: state.viewport));
  }

  @override
  Future<void> close() async {
    await _accelerometerSubscription?.cancel();
    _ticker?.cancel();
    return super.close();
  }
}

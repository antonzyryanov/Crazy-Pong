part of '../level_bloc.dart';

class _LevelTickOutcome {
  const _LevelTickOutcome({
    required this.nextState,
    required this.playShowingScores,
    required this.playEncounteredTarget,
    required this.playEncounteredEnemy,
  });

  factory _LevelTickOutcome.noChange() => const _LevelTickOutcome(
    nextState: null,
    playShowingScores: false,
    playEncounteredTarget: false,
    playEncounteredEnemy: false,
  );

  final LevelState? nextState;
  final bool playShowingScores;
  final bool playEncounteredTarget;
  final bool playEncounteredEnemy;
}

class _LevelTickCoordinator {
  const _LevelTickCoordinator({
    required _LevelBallLogic ballLogic,
    required _LevelEnemyLogic enemyLogic,
  }) : _ballLogic = ballLogic,
       _enemyLogic = enemyLogic;

  final _LevelBallLogic _ballLogic;
  final _LevelEnemyLogic _enemyLogic;

  _LevelTickOutcome coordinate({
    required LevelState state,
    required double dt,
    required double tiltX,
    required double tiltY,
    required DateTime now,
  }) {
    if (state.levelType == null || state.status == LevelStatus.finished) {
      return _LevelTickOutcome.noChange();
    }

    final viewport = state.viewport;
    if (viewport == Size.zero) {
      return _LevelTickOutcome.noChange();
    }

    if (state.status == LevelStatus.gameOverShowing) {
      final finishedAt = state.finishedAt;
      if (finishedAt != null &&
          now.difference(finishedAt) >= AppDurations.gameOverDisplay) {
        return _LevelTickOutcome(
          nextState: state.copyWith(status: LevelStatus.finished),
          playShowingScores: true,
          playEncounteredTarget: false,
          playEncounteredEnemy: false,
        );
      }
      return _LevelTickOutcome.noChange();
    }

    final enemyFrame = _enemyLogic.advanceFrame(
      state: state,
      dt: dt,
      viewport: viewport,
    );

    int points = state.points;
    int lives = state.lives;
    int spawnedEnemyBatches = state.spawnedEnemyBatches;
    var dynamicEnemies = List<DynamicEnemy>.from(state.dynamicEnemies);
    var nextStatus = state.status;
    DateTime? finishedAt = state.finishedAt;

    final ballFrame = _ballLogic.advanceFrame(
      state: state,
      dt: dt,
      tiltX: tiltX,
      tiltY: tiltY,
      viewport: viewport,
      targetRect: enemyFrame.targetRect,
      lowerTargetRect: enemyFrame.lowerTargetRect,
      enemyRects: enemyFrame.enemyRects,
    );

    points += ballFrame.scoredTargets;
    if (ballFrame.hitEnemy) {
      lives -= 1;
    }

    final enemyProgress = _enemyLogic.progressDynamicEnemies(
      levelDifficulty: state.levelType!.levelDifficulty,
      points: points,
      spawnedEnemyBatches: spawnedEnemyBatches,
      dynamicEnemies: dynamicEnemies,
      viewport: viewport,
      dt: dt,
    );
    spawnedEnemyBatches = enemyProgress.spawnedEnemyBatches;
    dynamicEnemies = enemyProgress.dynamicEnemies;

    final elapsed = state.elapsed + Duration(milliseconds: (dt * 1000).round());
    final timeLeft = elapsed;

    if (lives <= 0) {
      nextStatus = LevelStatus.gameOverShowing;
      finishedAt ??= now;
    }

    return _LevelTickOutcome(
      nextState: state.copyWith(
        status: nextStatus,
        points: points,
        lives: lives,
        ballCenter: ballFrame.ballCenter,
        ballVelocity: ballFrame.ballVelocity,
        leftEnemyAxis: enemyFrame.leftEnemyAxis,
        rightEnemyAxis: enemyFrame.rightEnemyAxis,
        bottomEnemyAxis: enemyFrame.bottomEnemyAxis,
        targetAxis: enemyFrame.targetAxis,
        targetDirection: enemyFrame.targetDirection,
        lowerTargetAxis: enemyFrame.lowerTargetAxis,
        lowerTargetDirection: enemyFrame.lowerTargetDirection,
        enemyDirection: enemyFrame.enemyDirection,
        timeLeft: timeLeft,
        elapsed: elapsed,
        finishedAt: finishedAt,
        spawnedEnemyBatches: spawnedEnemyBatches,
        dynamicEnemies: dynamicEnemies,
      ),
      playShowingScores: false,
      playEncounteredTarget: ballFrame.scoredTargets > 0,
      playEncounteredEnemy: ballFrame.hitEnemy,
    );
  }
}

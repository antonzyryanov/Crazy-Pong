part of '../level_bloc.dart';

class _LevelEnemyFrame {
  const _LevelEnemyFrame({
    required this.leftEnemyAxis,
    required this.rightEnemyAxis,
    required this.bottomEnemyAxis,
    required this.targetAxis,
    required this.targetDirection,
    required this.lowerTargetAxis,
    required this.lowerTargetDirection,
    required this.enemyDirection,
    required this.targetRect,
    required this.lowerTargetRect,
    required this.enemyRects,
  });

  final double leftEnemyAxis;
  final double rightEnemyAxis;
  final double bottomEnemyAxis;
  final double targetAxis;
  final double targetDirection;
  final double lowerTargetAxis;
  final double lowerTargetDirection;
  final double enemyDirection;
  final Rect targetRect;
  final Rect lowerTargetRect;
  final List<Rect> enemyRects;
}

class _LevelEnemyProgress {
  const _LevelEnemyProgress({
    required this.spawnedEnemyBatches,
    required this.dynamicEnemies,
  });

  final int spawnedEnemyBatches;
  final List<DynamicEnemy> dynamicEnemies;
}

class _LevelEnemyLogic {
  static const double _enemySpeed = 80;
  static const double _dynamicEnemySpeed = 95;
  static const double _targetSpeed = 90;
  static const double _lowerTargetSpeedFactor = 1.2;

  final math.Random _random = math.Random();

  _LevelEnemyFrame advanceFrame({
    required LevelState state,
    required double dt,
    required Size viewport,
  }) {
    var enemyDirection = state.enemyDirection;
    var leftEnemyAxis =
        state.leftEnemyAxis +
        enemyDirection * (_enemySpeed * dt) / viewport.height;
    var rightEnemyAxis =
        state.rightEnemyAxis -
        enemyDirection * (_enemySpeed * dt) / viewport.height;
    var bottomEnemyAxis =
        state.bottomEnemyAxis +
        enemyDirection * (_enemySpeed * dt) / viewport.width;

    if (leftEnemyAxis < 0.1 ||
        leftEnemyAxis > 0.9 ||
        bottomEnemyAxis < 0.1 ||
        bottomEnemyAxis > 0.9) {
      enemyDirection *= -1;
      leftEnemyAxis = leftEnemyAxis.clamp(0.1, 0.9);
      rightEnemyAxis = rightEnemyAxis.clamp(0.1, 0.9);
      bottomEnemyAxis = bottomEnemyAxis.clamp(0.1, 0.9);
    }

    var targetDirection = state.targetDirection;
    var targetAxis = state.targetAxis;
    var lowerTargetDirection = state.lowerTargetDirection;
    var lowerTargetAxis = state.lowerTargetAxis;
    if (state.levelType!.movingTarget) {
      targetAxis += targetDirection * (_targetSpeed * dt) / viewport.width;
      if (targetAxis < 0.2 || targetAxis > 0.8) {
        targetDirection *= -1;
        targetAxis = targetAxis.clamp(0.2, 0.8);
      }

      final lowerTargetSpeed = _targetSpeed * _lowerTargetSpeedFactor;
      lowerTargetAxis +=
          lowerTargetDirection * (lowerTargetSpeed * dt) / viewport.width;
      if (lowerTargetAxis < 0.2 || lowerTargetAxis > 0.8) {
        lowerTargetDirection *= -1;
        lowerTargetAxis = lowerTargetAxis.clamp(0.2, 0.8);
      }
    } else {
      targetAxis = 0.5;
      lowerTargetAxis = 0.5;
    }

    final borderThickness = AppDimensions.borderThicknessForSize(viewport);
    final targetWidth = AppDimensions.targetWidthForSize(viewport);
    final targetHeight = AppDimensions.targetHeightForSize(viewport);
    final enemySize = AppDimensions.enemySizeForSize(viewport);

    final targetCenter = Offset(
      targetAxis * viewport.width,
      borderThickness + targetHeight / 2,
    );
    final targetRect = Rect.fromCenter(
      center: targetCenter,
      width: targetWidth,
      height: targetHeight,
    );

    final lowerTargetCenter = Offset(
      lowerTargetAxis * viewport.width,
      viewport.height - borderThickness - targetHeight / 2,
    );
    final lowerTargetRect = Rect.fromCenter(
      center: lowerTargetCenter,
      width: targetWidth,
      height: targetHeight,
    );

    final leftEnemyCenter = Offset(
      borderThickness + enemySize / 2,
      leftEnemyAxis * viewport.height,
    );
    final rightEnemyCenter = Offset(
      viewport.width - borderThickness - enemySize / 2,
      rightEnemyAxis * viewport.height,
    );
    final bottomEnemyCenter = Offset(
      bottomEnemyAxis * viewport.width,
      viewport.height - borderThickness - enemySize / 2,
    );

    final enemyRects = [
      Rect.fromCenter(
        center: leftEnemyCenter,
        width: enemySize,
        height: enemySize,
      ),
      Rect.fromCenter(
        center: rightEnemyCenter,
        width: enemySize,
        height: enemySize,
      ),
      Rect.fromCenter(
        center: bottomEnemyCenter,
        width: enemySize,
        height: enemySize,
      ),
      ...state.dynamicEnemies.map(
        (enemy) => Rect.fromCenter(
          center: enemy.center,
          width: enemySize,
          height: enemySize,
        ),
      ),
    ];

    return _LevelEnemyFrame(
      leftEnemyAxis: leftEnemyAxis,
      rightEnemyAxis: rightEnemyAxis,
      bottomEnemyAxis: bottomEnemyAxis,
      targetAxis: targetAxis,
      targetDirection: targetDirection,
      lowerTargetAxis: lowerTargetAxis,
      lowerTargetDirection: lowerTargetDirection,
      enemyDirection: enemyDirection,
      targetRect: targetRect,
      lowerTargetRect: lowerTargetRect,
      enemyRects: enemyRects,
    );
  }

  _LevelEnemyProgress progressDynamicEnemies({
    required int levelDifficulty,
    required int points,
    required int spawnedEnemyBatches,
    required List<DynamicEnemy> dynamicEnemies,
    required Size viewport,
    required double dt,
  }) {
    var nextSpawnedEnemyBatches = spawnedEnemyBatches;
    var nextDynamicEnemies = List<DynamicEnemy>.from(dynamicEnemies);

    final targetSpawnBatches = points ~/ (7 - levelDifficulty);
    if (targetSpawnBatches > nextSpawnedEnemyBatches) {
      final countToSpawn = targetSpawnBatches - nextSpawnedEnemyBatches;
      for (var i = 0; i < countToSpawn; i++) {
        nextDynamicEnemies = [
          ...nextDynamicEnemies,
          _spawnDynamicEnemy(viewport),
        ];
      }
      nextSpawnedEnemyBatches = targetSpawnBatches;
    }

    nextDynamicEnemies = nextDynamicEnemies
        .map((enemy) => _moveDynamicEnemy(enemy, viewport, dt))
        .toList(growable: false);

    return _LevelEnemyProgress(
      spawnedEnemyBatches: nextSpawnedEnemyBatches,
      dynamicEnemies: nextDynamicEnemies,
    );
  }

  DynamicEnemy _spawnDynamicEnemy(Size viewport) {
    final enemyHalf = AppDimensions.enemySizeForSize(viewport) / 2;
    final borderThickness = AppDimensions.borderThicknessForSize(viewport);
    final minX = borderThickness + enemyHalf;
    final maxX = viewport.width - borderThickness - enemyHalf;
    final minY = borderThickness + enemyHalf;
    final maxY = viewport.height - borderThickness - enemyHalf;

    return DynamicEnemy(
      center: Offset(
        minX + (_random.nextDouble() * (maxX - minX)),
        minY + (_random.nextDouble() * (maxY - minY)),
      ),
      path: _random.nextBool() ? EnemyPath.horizontal : EnemyPath.vertical,
      direction: _random.nextBool() ? 1.0 : -1.0,
    );
  }

  DynamicEnemy _moveDynamicEnemy(DynamicEnemy enemy, Size viewport, double dt) {
    final enemyHalf = AppDimensions.enemySizeForSize(viewport) / 2;
    final borderThickness = AppDimensions.borderThicknessForSize(viewport);
    final minX = borderThickness + enemyHalf;
    final maxX = viewport.width - borderThickness - enemyHalf;
    final minY = borderThickness + enemyHalf;
    final maxY = viewport.height - borderThickness - enemyHalf;

    if (enemy.path == EnemyPath.horizontal) {
      var nextX = enemy.center.dx + enemy.direction * _dynamicEnemySpeed * dt;
      var direction = enemy.direction;
      if (nextX < minX || nextX > maxX) {
        direction *= -1;
        nextX = nextX.clamp(minX, maxX);
      }
      return enemy.copyWith(
        center: Offset(nextX, enemy.center.dy),
        direction: direction,
      );
    }

    var nextY = enemy.center.dy + enemy.direction * _dynamicEnemySpeed * dt;
    var direction = enemy.direction;
    if (nextY < minY || nextY > maxY) {
      direction *= -1;
      nextY = nextY.clamp(minY, maxY);
    }
    return enemy.copyWith(
      center: Offset(enemy.center.dx, nextY),
      direction: direction,
    );
  }
}

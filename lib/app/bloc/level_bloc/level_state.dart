part of 'level_bloc.dart';

enum LevelStatus { idle, playing, gameOverShowing, finished }

enum EnemyPath { horizontal, vertical }

class DynamicEnemy extends Equatable {
  const DynamicEnemy({
    required this.center,
    required this.path,
    required this.direction,
  });

  final Offset center;
  final EnemyPath path;
  final double direction;

  DynamicEnemy copyWith({Offset? center, EnemyPath? path, double? direction}) {
    return DynamicEnemy(
      center: center ?? this.center,
      path: path ?? this.path,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [center, path, direction];
}

class LevelState extends Equatable {
  const LevelState({
    required this.status,
    required this.levelType,
    required this.playerName,
    required this.viewport,
    required this.ballCenter,
    required this.ballVelocity,
    required this.leftEnemyAxis,
    required this.rightEnemyAxis,
    required this.bottomEnemyAxis,
    required this.targetAxis,
    required this.targetDirection,
    required this.lowerTargetAxis,
    required this.lowerTargetDirection,
    required this.enemyDirection,
    required this.points,
    required this.spawnedEnemyBatches,
    required this.dynamicEnemies,
    required this.lives,
    required this.timeLeft,
    required this.totalDuration,
    required this.elapsed,
    required this.errorMessage,
    required this.finishedAt,
  });

  factory LevelState.initial() => LevelState(
    status: LevelStatus.idle,
    levelType: null,
    playerName: '',
    viewport: Size.zero,
    ballCenter: Offset.zero,
    ballVelocity: const Offset(120, -150),
    leftEnemyAxis: 0,
    rightEnemyAxis: 0,
    bottomEnemyAxis: 0,
    targetAxis: 0,
    targetDirection: 1,
    lowerTargetAxis: 0,
    lowerTargetDirection: 1,
    enemyDirection: 1,
    points: 0,
    spawnedEnemyBatches: 0,
    dynamicEnemies: const [],
    lives: 3,
    timeLeft: Duration.zero,
    totalDuration: Duration.zero,
    elapsed: Duration.zero,
    errorMessage: null,
    finishedAt: null,
  );

  final LevelStatus status;
  final LevelType? levelType;
  final String playerName;
  final Size viewport;
  final Offset ballCenter;
  final Offset ballVelocity;
  final double leftEnemyAxis;
  final double rightEnemyAxis;
  final double bottomEnemyAxis;
  final double targetAxis;
  final double targetDirection;
  final double lowerTargetAxis;
  final double lowerTargetDirection;
  final double enemyDirection;
  final int points;
  final int spawnedEnemyBatches;
  final List<DynamicEnemy> dynamicEnemies;
  final int lives;
  final Duration timeLeft;
  final Duration totalDuration;
  final Duration elapsed;
  final String? errorMessage;
  final DateTime? finishedAt;

  bool get isPlayable => status == LevelStatus.playing;

  LevelState copyWith({
    LevelStatus? status,
    LevelType? levelType,
    String? playerName,
    Size? viewport,
    Offset? ballCenter,
    Offset? ballVelocity,
    double? leftEnemyAxis,
    double? rightEnemyAxis,
    double? bottomEnemyAxis,
    double? targetAxis,
    double? targetDirection,
    double? lowerTargetAxis,
    double? lowerTargetDirection,
    double? enemyDirection,
    int? points,
    int? spawnedEnemyBatches,
    List<DynamicEnemy>? dynamicEnemies,
    int? lives,
    Duration? timeLeft,
    Duration? totalDuration,
    Duration? elapsed,
    String? errorMessage,
    DateTime? finishedAt,
  }) {
    return LevelState(
      status: status ?? this.status,
      levelType: levelType ?? this.levelType,
      playerName: playerName ?? this.playerName,
      viewport: viewport ?? this.viewport,
      ballCenter: ballCenter ?? this.ballCenter,
      ballVelocity: ballVelocity ?? this.ballVelocity,
      leftEnemyAxis: leftEnemyAxis ?? this.leftEnemyAxis,
      rightEnemyAxis: rightEnemyAxis ?? this.rightEnemyAxis,
      bottomEnemyAxis: bottomEnemyAxis ?? this.bottomEnemyAxis,
      targetAxis: targetAxis ?? this.targetAxis,
      targetDirection: targetDirection ?? this.targetDirection,
      lowerTargetAxis: lowerTargetAxis ?? this.lowerTargetAxis,
      lowerTargetDirection: lowerTargetDirection ?? this.lowerTargetDirection,
      enemyDirection: enemyDirection ?? this.enemyDirection,
      points: points ?? this.points,
      spawnedEnemyBatches: spawnedEnemyBatches ?? this.spawnedEnemyBatches,
      dynamicEnemies: dynamicEnemies ?? this.dynamicEnemies,
      lives: lives ?? this.lives,
      timeLeft: timeLeft ?? this.timeLeft,
      totalDuration: totalDuration ?? this.totalDuration,
      elapsed: elapsed ?? this.elapsed,
      errorMessage: errorMessage,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  List<Object?> get props => [
    status,
    levelType,
    playerName,
    viewport,
    ballCenter,
    ballVelocity,
    leftEnemyAxis,
    rightEnemyAxis,
    bottomEnemyAxis,
    targetAxis,
    targetDirection,
    lowerTargetAxis,
    lowerTargetDirection,
    enemyDirection,
    points,
    spawnedEnemyBatches,
    dynamicEnemies,
    lives,
    timeLeft,
    totalDuration,
    elapsed,
    errorMessage,
    finishedAt,
  ];
}

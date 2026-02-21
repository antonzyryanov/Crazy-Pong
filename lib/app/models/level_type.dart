enum LevelType {
  basketball(
    menuKey: 'basketballLevel',
    ballAsset: 'assets/images/balls/ball_basketball.png',
    fieldAsset: 'assets/images/fields/field_basketball.png',
    enemyTexture: 'assets/images/enemies/enemy_1.png',
    movingTarget: false,
    levelDifficulty: 1,
  ),
  football(
    menuKey: 'footballLevel',
    ballAsset: 'assets/images/balls/ball_football.png',
    fieldAsset: 'assets/images/fields/field_football.png',
    enemyTexture: 'assets/images/enemies/enemy_2.png',
    movingTarget: false,
    levelDifficulty: 2,
  ),
  soccer(
    menuKey: 'soccerLevel',
    ballAsset: 'assets/images/balls/ball_soccer.png',
    fieldAsset: 'assets/images/fields/field_soccer.png',
    enemyTexture: 'assets/images/enemies/enemy_3.png',
    movingTarget: false,
    levelDifficulty: 3,
  ),
  tennis(
    menuKey: 'tennisLevel',
    ballAsset: 'assets/images/balls/ball_tennis.png',
    fieldAsset: 'assets/images/fields/field_tennis.png',
    enemyTexture: 'assets/images/enemies/enemy_4.png',
    movingTarget: true,
    levelDifficulty: 4,
  ),
  baseball(
    menuKey: 'baseballLevel',
    ballAsset: 'assets/images/balls/ball_baseball.png',
    fieldAsset: 'assets/images/fields/field_baseball.png',
    enemyTexture: 'assets/images/enemies/enemy_5.png',
    movingTarget: true,
    levelDifficulty: 5,
  );

  const LevelType({
    required this.menuKey,
    required this.ballAsset,
    required this.fieldAsset,
    required this.enemyTexture,
    required this.movingTarget,
    required this.levelDifficulty,
  });

  final String menuKey;
  final String ballAsset;
  final String fieldAsset;
  final String enemyTexture;
  final bool movingTarget;
  final int levelDifficulty;
}

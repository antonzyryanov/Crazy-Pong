import 'package:flutter/material.dart';

import 'package:crazy_pong/app/bloc/level_bloc/level_bloc.dart';

class GameEnemiesLayer extends StatelessWidget {
  const GameEnemiesLayer({
    required this.enemyTexture,
    required this.borderThickness,
    required this.enemySize,
    required this.leftEnemyY,
    required this.rightEnemyY,
    required this.bottomEnemyX,
    required this.dynamicEnemies,
    super.key,
  });

  final String enemyTexture;
  final double borderThickness;
  final double enemySize;
  final double leftEnemyY;
  final double rightEnemyY;
  final double bottomEnemyX;
  final List<DynamicEnemy> dynamicEnemies;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: borderThickness,
          top: leftEnemyY - (enemySize / 2),
          width: enemySize,
          height: enemySize,
          child: _EnemySprite(assetPath: enemyTexture),
        ),
        Positioned(
          right: borderThickness,
          top: rightEnemyY - (enemySize / 2),
          width: enemySize,
          height: enemySize,
          child: _EnemySprite(assetPath: enemyTexture),
        ),
        Positioned(
          left: bottomEnemyX - (enemySize / 2),
          bottom: borderThickness,
          width: enemySize,
          height: enemySize,
          child: _EnemySprite(assetPath: enemyTexture),
        ),
        ...dynamicEnemies.map(
          (enemy) => Positioned(
            left: enemy.center.dx - (enemySize / 2),
            top: enemy.center.dy - (enemySize / 2),
            width: enemySize,
            height: enemySize,
            child: _EnemySprite(assetPath: enemyTexture),
          ),
        ),
      ],
    );
  }
}

class _EnemySprite extends StatelessWidget {
  const _EnemySprite({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const DecoratedBox(
        decoration: BoxDecoration(color: Colors.redAccent),
      ),
    );
  }
}

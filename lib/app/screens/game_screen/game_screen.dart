import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crazy_pong/app/bloc/level_bloc/level_bloc.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_layout.dart';
import '../../../app_design/app_text_styles.dart';
import '../../../localizations/app_localizations.dart';
import 'widgets/game_hud_layer.dart';
import 'widgets/game_over_showing_overlay.dart';
import 'widgets/game_targets_layer.dart';
import 'widgets/game_enemies_layer.dart';
import 'widgets/level_finished_overlay.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.levelBloc,
    required this.onBackToMenu,
    super.key,
  });

  final LevelBloc levelBloc;
  final VoidCallback onBackToMenu;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider.value(
      value: levelBloc,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            levelBloc.add(
              LevelViewportChanged(
                Size(constraints.maxWidth, constraints.maxHeight),
              ),
            );

            return BlocBuilder<LevelBloc, LevelState>(
              builder: (context, state) {
                final level = state.levelType;
                if (level == null) {
                  return const SizedBox.shrink();
                }

                final hudTopInset = AppLayout.hudTopInset(context);
                final hudEdgeInset = AppLayout.hudEdgeInset(context);
                final gameOverSize = AppLayout.gameOverSize(context);
                final bottomActionInset = AppLayout.bottomActionInset(context);

                final size = state.viewport;
                final layoutSize = size == Size.zero
                    ? Size(constraints.maxWidth, constraints.maxHeight)
                    : size;
                final borderThickness = AppDimensions.borderThicknessForSize(
                  layoutSize,
                );
                final targetWidth = AppDimensions.targetWidthForSize(
                  layoutSize,
                );
                final targetHeight = AppDimensions.targetHeightForSize(
                  layoutSize,
                );
                final enemySize = AppDimensions.enemySizeForSize(layoutSize);
                final ballSize = AppDimensions.ballSizeForSize(layoutSize);
                final targetCenterX = state.targetAxis * size.width;
                final lowerTargetCenterX = state.lowerTargetAxis * size.width;
                final leftEnemyY = state.leftEnemyAxis * size.height;
                final rightEnemyY = state.rightEnemyAxis * size.height;
                final bottomEnemyX = state.bottomEnemyAxis * size.width;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        level.fieldAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const ColoredBox(color: Colors.black54),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.black,
                              width: borderThickness,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GameTargetsLayer(
                      targetCenterX: targetCenterX,
                      lowerTargetCenterX: lowerTargetCenterX,
                      borderThickness: borderThickness,
                      targetWidth: targetWidth,
                      targetHeight: targetHeight,
                    ),
                    GameEnemiesLayer(
                      enemyTexture: level.enemyTexture,
                      borderThickness: borderThickness,
                      enemySize: enemySize,
                      leftEnemyY: leftEnemyY,
                      rightEnemyY: rightEnemyY,
                      bottomEnemyX: bottomEnemyX,
                      dynamicEnemies: state.dynamicEnemies,
                    ),
                    Positioned(
                      left: state.ballCenter.dx - (ballSize / 2),
                      top: state.ballCenter.dy - (ballSize / 2),
                      width: ballSize,
                      height: ballSize,
                      child: Image.asset(
                        level.ballAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                    ),
                    GameHudLayer(
                      hudTopInset: hudTopInset,
                      hudEdgeInset: hudEdgeInset,
                      livesLabel: localizations.t('lives'),
                      pointsLabel: localizations.t('points'),
                      timeLabel: localizations.t('time'),
                      lives: state.lives,
                      points: state.points,
                      elapsed: state.elapsed,
                    ),
                    if (state.status == LevelStatus.gameOverShowing)
                      GameOverShowingOverlay(
                        gameOverSize: gameOverSize,
                        gameOverText: localizations.t('gameOver'),
                        gameOverTextStyle: AppTextStyles.title(context),
                      ),
                    if (state.status == LevelStatus.finished)
                      LevelFinishedOverlay(
                        points: state.points,
                        scoreLabel: localizations.t('scoreValue'),
                        backLabel: localizations.t('backToMainMenu'),
                        scoreTextStyle: AppTextStyles.scoreLarge(context),
                        bottomActionInset: bottomActionInset,
                        buttonHeight: AppDimensions.buttonHeight(context),
                        onBackToMenu: onBackToMenu,
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GameTargetsLayer extends StatelessWidget {
  const GameTargetsLayer({
    required this.targetCenterX,
    required this.lowerTargetCenterX,
    required this.borderThickness,
    required this.targetWidth,
    required this.targetHeight,
    super.key,
  });

  final double targetCenterX;
  final double lowerTargetCenterX;
  final double borderThickness;
  final double targetWidth;
  final double targetHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: targetCenterX - (targetWidth / 2),
          top: borderThickness,
          width: targetWidth,
          height: targetHeight,
          child: Image.asset(
            'assets/images/target/target.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const DecoratedBox(
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
          ),
        ),
        Positioned(
          left: lowerTargetCenterX - (targetWidth / 2),
          bottom: borderThickness,
          width: targetWidth,
          height: targetHeight,
          child: Image.asset(
            'assets/images/target/target.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const DecoratedBox(
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }
}

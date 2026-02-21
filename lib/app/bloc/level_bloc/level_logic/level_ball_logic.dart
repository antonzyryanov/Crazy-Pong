part of '../level_bloc.dart';

class _LevelBallFrame {
  const _LevelBallFrame({
    required this.ballCenter,
    required this.ballVelocity,
    required this.scoredTargets,
    required this.hitEnemy,
  });

  final Offset ballCenter;
  final Offset ballVelocity;
  final int scoredTargets;
  final bool hitEnemy;
}

class _LevelBallLogic {
  static const Offset initialVelocity = Offset(120, -150);
  static const double _ballBaseSpeed = 200;
  static const double _maxBallSpeed = 360;
  static const double _tiltDeadZone = 0.35;
  static const double _steerFactor = 0.25;

  _LevelBallFrame advanceFrame({
    required LevelState state,
    required double dt,
    required double tiltX,
    required double tiltY,
    required Size viewport,
    required Rect targetRect,
    required Rect lowerTargetRect,
    required List<Rect> enemyRects,
  }) {
    final borderThickness = AppDimensions.borderThicknessForSize(viewport);
    final ballSize = AppDimensions.ballSizeForSize(viewport);
    final ballRadius = ballSize / 2;
    final left = borderThickness + ballRadius;
    final right = viewport.width - borderThickness - ballRadius;
    final top = borderThickness + ballRadius;
    final bottom = viewport.height - borderThickness - ballRadius;

    var velocity = _velocityWithTilt(
      current: state.ballVelocity,
      tiltX: tiltX,
      tiltY: tiltY,
    );

    var ballCenter = state.ballCenter.translate(
      velocity.dx * dt,
      velocity.dy * dt,
    );

    int scoredTargets = 0;
    final ballRect = Rect.fromCircle(center: ballCenter, radius: ballRadius);

    if (ballRect.overlaps(targetRect) && velocity.dy < 0) {
      scoredTargets += 1;
      ballCenter = Offset(viewport.width / 2, viewport.height / 2);
      velocity = Offset(-velocity.dx, velocity.dy.abs());
    }

    if (ballRect.overlaps(lowerTargetRect) && velocity.dy > 0) {
      scoredTargets += 1;
      ballCenter = Offset(viewport.width / 2, viewport.height / 2);
      velocity = Offset(-velocity.dx, -velocity.dy.abs());
    }

    final hitEnemy = enemyRects.any(ballRect.overlaps);
    if (hitEnemy) {
      ballCenter = Offset(viewport.width / 2, viewport.height / 2);
      velocity = initialVelocity;
    }

    if (ballCenter.dx <= left) {
      ballCenter = Offset(left, ballCenter.dy);
      velocity = Offset(velocity.dx.abs(), velocity.dy);
    }
    if (ballCenter.dx >= right) {
      ballCenter = Offset(right, ballCenter.dy);
      velocity = Offset(-velocity.dx.abs(), velocity.dy);
    }
    if (ballCenter.dy <= top) {
      ballCenter = Offset(ballCenter.dx, top);
      velocity = Offset(velocity.dx, velocity.dy.abs());
    }
    if (ballCenter.dy >= bottom) {
      ballCenter = Offset(ballCenter.dx, bottom);
      velocity = Offset(velocity.dx, -velocity.dy.abs());
    }

    return _LevelBallFrame(
      ballCenter: ballCenter,
      ballVelocity: velocity,
      scoredTargets: scoredTargets,
      hitEnemy: hitEnemy,
    );
  }

  Offset _velocityWithTilt({
    required Offset current,
    required double tiltX,
    required double tiltY,
  }) {
    var velocity = current;
    final tiltVector = Offset(-tiltX, tiltY);
    final tiltMagnitude = tiltVector.distance;
    if (tiltMagnitude > _tiltDeadZone) {
      final desiredVelocity = Offset(
        (tiltVector.dx / tiltMagnitude) * _ballBaseSpeed,
        (tiltVector.dy / tiltMagnitude) * _ballBaseSpeed,
      );
      velocity =
          Offset.lerp(velocity, desiredVelocity, _steerFactor) ?? velocity;
    }

    final speed = math.sqrt(
      velocity.dx * velocity.dx + velocity.dy * velocity.dy,
    );
    if (speed < _ballBaseSpeed) {
      final factor = _ballBaseSpeed / (speed == 0 ? 1 : speed);
      return Offset(velocity.dx * factor, velocity.dy * factor);
    }
    if (speed > _maxBallSpeed) {
      final factor = _maxBallSpeed / speed;
      return Offset(velocity.dx * factor, velocity.dy * factor);
    }

    return velocity;
  }
}

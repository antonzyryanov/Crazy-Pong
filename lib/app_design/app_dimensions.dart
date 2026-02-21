import 'package:flutter/widgets.dart';

import 'app_layout.dart';

abstract final class AppDimensions {
  static double _scaleForWidth(double width) {
    if (width >= AppLayout.desktopBreakpoint) {
      return 1.25;
    }
    if (width >= AppLayout.tabletBreakpoint) {
      return 1.12;
    }
    return 1.0;
  }

  static double _scaleForSize(Size size) => _scaleForWidth(size.width);

  static double borderThicknessForSize(Size size) => 5 * _scaleForSize(size);
  static double ballSizeForSize(Size size) => 44 * _scaleForSize(size);
  static double targetWidthForSize(Size size) => 110 * _scaleForSize(size);
  static double targetHeightForSize(Size size) => 44 * _scaleForSize(size);
  static double enemySizeForSize(Size size) => 42 * _scaleForSize(size);

  static double safePadding(BuildContext context) =>
      AppLayout.screenPadding(context);
  static double buttonHeight(BuildContext context) =>
      56 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double titleToFieldGap(BuildContext context) =>
      24 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double fieldToButtonGap(BuildContext context) =>
      18 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double menuTopGap(BuildContext context) =>
      6 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double menuIconToListGap(BuildContext context) =>
      16 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double menuButtonRadius(BuildContext context) =>
      14 * _scaleForWidth(MediaQuery.of(context).size.width);
  static double focusedInputBorderWidth(BuildContext context) =>
      2 * _scaleForWidth(MediaQuery.of(context).size.width);
}

import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_layout.dart';
import '../../../localizations/app_localizations.dart';
import '../../models/level_type.dart';
import 'models/menu_action_item.dart';
import 'widgets/menu_actions_list.dart';
import 'widgets/menu_header_icon.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    required this.onLevelSelected,
    required this.onScores,
    required this.onInstructions,
    required this.onSettings,
    super.key,
  });

  final ValueChanged<LevelType> onLevelSelected;
  final VoidCallback onScores;
  final VoidCallback onInstructions;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final iconSize = AppLayout.menuIconSize(context);
    final screenPadding = AppLayout.screenPadding(context);
    final listGap = AppLayout.listGap(context);
    final items = [
      MenuActionItem(
        label: localizations.t(LevelType.basketball.menuKey),
        onTap: () => onLevelSelected(LevelType.basketball),
      ),
      MenuActionItem(
        label: localizations.t(LevelType.football.menuKey),
        onTap: () => onLevelSelected(LevelType.football),
      ),
      MenuActionItem(
        label: localizations.t(LevelType.soccer.menuKey),
        onTap: () => onLevelSelected(LevelType.soccer),
      ),
      MenuActionItem(
        label: localizations.t(LevelType.tennis.menuKey),
        onTap: () => onLevelSelected(LevelType.tennis),
      ),
      MenuActionItem(
        label: localizations.t(LevelType.baseball.menuKey),
        onTap: () => onLevelSelected(LevelType.baseball),
      ),
      MenuActionItem(label: localizations.t('bestScores'), onTap: onScores),
      MenuActionItem(
        label: localizations.t('instructions'),
        onTap: onInstructions,
      ),
      MenuActionItem(label: localizations.t('settings'), onTap: onSettings),
    ];

    return Scaffold(
      body: Container(
        color: AppColors.menuBackground,
        padding: EdgeInsets.all(screenPadding),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppDimensions.menuTopGap(context)),
              MenuHeaderIcon(iconSize: iconSize),
              SizedBox(height: AppDimensions.menuIconToListGap(context)),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppLayout.menuContentMaxWidth(context),
                    ),
                    child: MenuActionsList(items: items, listGap: listGap),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

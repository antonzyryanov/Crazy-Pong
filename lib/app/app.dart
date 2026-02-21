import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crazy_pong/app/bloc/main_bloc/main_bloc.dart';

import '../app_design/app_colors.dart';
import '../localizations/app_localizations.dart';
import 'repositories/score_repository.dart';
import 'router/app_route_parser.dart';
import 'router/app_router_delegate.dart';
import 'services/app_logger.dart';

class CrazyPongApp extends StatefulWidget {
  const CrazyPongApp({this.enableLevelTicker = true, super.key});

  final bool enableLevelTicker;

  @override
  State<CrazyPongApp> createState() => _CrazyPongAppState();
}

class _CrazyPongAppState extends State<CrazyPongApp> {
  late final MainBloc _mainBloc;
  late final AppRouterDelegate _routerDelegate;
  final AppRouteParser _routeParser = AppRouteParser();

  @override
  void initState() {
    super.initState();
    configureAppLogger();
    _mainBloc = MainBloc(
      scoreRepository: ScoreRepository(),
      enableLevelTicker: widget.enableLevelTicker,
    )..add(const MainStarted());
    _routerDelegate = AppRouterDelegate(mainBloc: _mainBloc);
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    _mainBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Crazy Pong',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.orange,
                brightness: Brightness.dark,
                primary: AppColors.orange,
                secondary: AppColors.yellow,
              ),
              scaffoldBackgroundColor: AppColors.orange,
              textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: AppColors.white,
                displayColor: AppColors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.menuButton,
                  foregroundColor: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ru')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (localizations == null) {
      throw StateError('AppLocalizations not found in context');
    }
    return localizations;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Crazy Pong',
      'enterNameTitle': 'Enter player name',
      'enterNameHint': 'Your name',
      'continue': 'Continue',
      'basketballLevel': 'Basketball level',
      'footballLevel': 'Football level',
      'soccerLevel': 'Soccer level',
      'tennisLevel': 'Tennis level',
      'baseballLevel': 'Baseball level',
      'bestScores': 'Best scores',
      'instructions': 'Instructions',
      'settings': 'Settings',
      'lives': 'Lives',
      'points': 'Points',
      'time': 'Time',
      'gameOver': 'Game Over',
      'backToMainMenu': 'Back to Main Menu',
      'scoreValue': 'Score',
      'language': 'Language',
      'sound': 'Sound',
      'english': 'English',
      'russian': 'Russian',
      'noScores': 'No scores yet',
      'sessionEnded': 'Session ended',
      'onboardingPage1': 'Welcome to Crazy Pong!',
      'onboardingPage2':
          'Help a little pig named Vic collect as many balls as possible into boxes',
      'onboardingPage3':
          'Avoid Vic\'s older brothers who are trying to stop him',
      'onboardingPage4': 'Use your device\'s gyroscope to control the ball',
    },
    'ru': {
      'appTitle': 'Crazy Pong',
      'enterNameTitle': 'Введите имя игрока',
      'enterNameHint': 'Ваше имя',
      'continue': 'Продолжить',
      'basketballLevel': 'Уровень баскетбол',
      'footballLevel': 'Уровень футбол',
      'soccerLevel': 'Уровень соккер',
      'tennisLevel': 'Уровень теннис',
      'baseballLevel': 'Уровень бейсбол',
      'bestScores': 'Лучшие результаты',
      'instructions': 'Инструкция',
      'settings': 'Настройки',
      'lives': 'Жизни',
      'points': 'Очки',
      'time': 'Время',
      'gameOver': 'Игра окончена',
      'backToMainMenu': 'Назад в главное меню',
      'scoreValue': 'Результат',
      'language': 'Язык',
      'sound': 'Звук',
      'english': 'Английский',
      'russian': 'Русский',
      'noScores': 'Результатов пока нет',
      'sessionEnded': 'Сессия завершена',
      'onboardingPage1': 'Добро пожаловать в Crazy Pong!',
      'onboardingPage2':
          'Помогите маленькому поросёнку Вику собрать как можно больше мячей в коробки',
      'onboardingPage3':
          'Избегайте старших братьев Вика, которые пытаются его остановить',
      'onboardingPage4':
          'Используйте гироскоп вашего устройства, чтобы управлять мячом',
    },
  };

  String t(String key) {
    final code = locale.languageCode;
    return _localizedValues[code]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

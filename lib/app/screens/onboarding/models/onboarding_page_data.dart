import 'package:crazy_pong/localizations/app_localizations.dart';

class OnboardingPageData {
  const OnboardingPageData({required this.text, required this.imagePath});

  final String text;
  final String imagePath;

  static List<OnboardingPageData> items(AppLocalizations localizations) => [
    OnboardingPageData(
      text: localizations.t('onboardingPage1'),
      imagePath: 'assets/images/onboarding/onboarding_vic.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage2'),
      imagePath: 'assets/images/target/target.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage3'),
      imagePath: 'assets/images/enemies/enemy_3.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage4'),
      imagePath: 'assets/images/onboarding/use_gyroscope.png',
    ),
  ];
}


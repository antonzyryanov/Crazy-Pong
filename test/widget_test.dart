import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crazy_pong/app/app.dart';

void main() {
  testWidgets('shows name input on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const CrazyPongApp(enableLevelTicker: false));
    await tester.pumpAndSettle();

    expect(find.text('Enter player name'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

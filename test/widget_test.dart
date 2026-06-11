import 'package:flutter_test/flutter_test.dart';

import 'package:move_with_us/main.dart';

void main() {
  testWidgets('App boots to the onboarding intro carousel', (tester) async {
    await tester.pumpWidget(const MoveWithUsApp());

    // The intro carousel shows the brand mark and the get-started CTA.
    expect(find.text('M O V E . W I T H U S'), findsOneWidget);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
  });

  testWidgets('Tapping Get Started navigates to Sign In', (tester) async {
    await tester.pumpWidget(const MoveWithUsApp());

    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('CONTINUE'), findsOneWidget);
  });
}

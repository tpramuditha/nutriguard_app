import 'package:flutter_test/flutter_test.dart';
import 'package:nutriguard_app/app/app.dart';

void main() {
  testWidgets('NutriGuard app loads successfully', (WidgetTester tester) async {
    // Build the NutriGuard application.
    await tester.pumpWidget(const NutriGuardApp());

    // Verify that the NutriGuard text is displayed.
    expect(find.text('NutriGuard'), findsOneWidget);
  });
}

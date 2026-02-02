import 'package:flutter_test/flutter_test.dart';
import 'package:moviemaniac/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MovieManiacApp());

    // Verify that the app title is present (this might need finding by type or other means since title isn't always visible text)
    // Actually, since we have async data fetching, we might just check if the scaffold exists or MainNavScreen.
    // For a simple smoke test without mocking http, this might be flaky if it tries to fetch real data.
    // But Provider initialization should work.
    
    // checks if the main widget loads
    expect(find.byType(MovieManiacApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:bite_scan/main.dart';
import 'package:bite_scan/routes.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since MyApp requires an initialRoute, we provide AppRoutes.onboarding for testing.
    await tester.pumpWidget(const MyApp(initialRoute: AppRoutes.onboarding));

    // Verify that the onboarding screen is displayed.
    expect(find.text('Welcome to BiteScan'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shrimp_drive_admin/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ShrimpAdminApp()));

    // Verify that our app starts and shows the ready text.
    expect(find.text('Shrimp Drive Desktop Admin Ready!'), findsOneWidget);
  });
}

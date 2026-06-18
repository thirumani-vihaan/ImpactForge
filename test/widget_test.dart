import 'package:flutter_test/flutter_test.dart';
import 'package:impactforge/main.dart';

void main() {
  testWidgets('App launches splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('ImpactForge'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tiopeliculas/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TioPeliculasApp());
    expect(find.byType(TioPeliculasApp), findsOneWidget);
  });
}

import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:easy_radial_gradient_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('live editor pumps and reacts to edited numbers', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    // A single radial-gradient circle preview is shown.
    expect(find.byType(RadialGradientBox), findsOneWidget);

    // The editable numeric literals are present.
    expect(find.byType(TextField), findsWidgets);

    // Editing a number (e.g. radius) updates state without throwing.
    await tester.enterText(find.byType(TextField).first, '0.9');
    await tester.pumpAndSettle();

    expect(find.byType(RadialGradientBox), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

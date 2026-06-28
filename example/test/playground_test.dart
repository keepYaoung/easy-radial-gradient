import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:easy_radial_gradient_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('playground pumps and reacts to controls', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    // Preview is present (Frost preset shows backdrop blur by default).
    expect(find.byType(RadialGradientBox), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);

    // Drag the first slider (blur) and make sure nothing throws.
    await tester.drag(find.byType(Slider).first, const Offset(60, 0));
    await tester.pumpAndSettle();

    // Switch to a colorful preset.
    await tester.tap(find.text('Sunset'));
    await tester.pumpAndSettle();

    // Toggle to the circle shape; the corner slider disappears.
    await tester.tap(find.text('Circle'));
    await tester.pumpAndSettle();

    expect(find.byType(RadialGradientBox), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

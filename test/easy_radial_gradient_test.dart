import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadialStop', () {
    test('effectiveColor multiplies color alpha by opacity', () {
      const stop = RadialStop(
        position: 0,
        color: Color(0xFF000000),
        opacity: 0.5,
      );
      expect(stop.effectiveColor.a, closeTo(0.5, 1e-6));
    });

    test('effectiveColor preserves color when opacity is 1', () {
      const c = Color(0x80112233);
      const stop = RadialStop(position: 0, color: c);
      expect(stop.effectiveColor, c);
    });

    test('named constructors pin the right position', () {
      expect(const RadialStop.start(color: Color(0xFFFFFFFF)).position, 0.0);
      expect(const RadialStop.end(color: Color(0xFFFFFFFF)).position, 1.0);
      expect(const RadialStop.at(0.3, color: Color(0xFFFFFFFF)).position, 0.3);
    });

    test('start/end carry opacity through', () {
      const s = RadialStop.end(color: Color(0xFFFF0000), opacity: 0.0);
      expect(s.opacity, 0.0);
      expect(s.effectiveColor.a, 0.0);
    });

    test('transparent constructor yields zero opacity', () {
      const stop = RadialStop.transparent(
        position: 1,
        color: Color(0xFFFF0000),
      );
      expect(stop.opacity, 0.0);
      expect(stop.effectiveColor.a, 0.0);
    });

    test('rejects out-of-range position and opacity in debug mode', () {
      expect(
        () => RadialStop(position: 1.5, color: const Color(0xFF000000)),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () =>
            RadialStop(position: 0, color: const Color(0xFF000000), opacity: 2),
        throwsA(isA<AssertionError>()),
      );
    });

    test('equality and copyWith', () {
      const a = RadialStop(
        position: 0.2,
        color: Color(0xFF010203),
        opacity: 0.4,
      );
      expect(a.copyWith(opacity: 0.4), a);
      expect(a.copyWith(position: 0.3), isNot(a));
    });
  });

  group('EasyRadialGradient', () {
    test('builds parallel colors/stops from RadialStops', () {
      final g = EasyRadialGradient(
        colorStops: const [
          RadialStop.start(color: Color(0xFFFF0000)),
          RadialStop.end(color: Color(0xFF0000FF), opacity: 0.0),
        ],
      );
      expect(g.colors.length, 2);
      expect(g.stops, [0.0, 1.0]);
      expect(g.colors.last.a, 0.0);
    });

    test('sorts stops by position regardless of input order', () {
      final g = EasyRadialGradient(
        colorStops: const [
          RadialStop.end(color: Color(0xFF0000FF)),
          RadialStop.start(color: Color(0xFFFF0000)),
          RadialStop.at(0.5, color: Color(0xFF00FF00)),
        ],
      );
      expect(g.stops, [0.0, 0.5, 1.0]);
      expect(g.colors.first, const Color(0xFFFF0000));
    });

    test('is a RadialGradient usable in BoxDecoration', () {
      final g = EasyRadialGradient.glow(const Color(0xFF00FFFF));
      expect(g, isA<RadialGradient>());
      expect(g.createShader(const Rect.fromLTWH(0, 0, 100, 100)), isNotNull);
    });

    test('asserts at least two stops', () {
      expect(
        () => EasyRadialGradient(
          colorStops: const [RadialStop.start(color: Color(0xFF000000))],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copyWith preserves stops', () {
      final g = EasyRadialGradient.glow(const Color(0xFF00FFFF));
      final g2 = g.copyWith(radius: 0.8);
      expect(g2.radius, 0.8);
      expect(g2.radialStops, g.radialStops);
    });

    test('supports an arbitrary number of .at stops (6 stops, shuffled)', () {
      final g = EasyRadialGradient(
        colorStops: const [
          RadialStop.at(0.75, color: Color(0xFF7C4DFF), opacity: 0.4),
          RadialStop.start(color: Color(0xFFFF4D8D)),
          RadialStop.at(0.50, color: Color(0xFF4DD0FF), opacity: 0.6),
          RadialStop.end(color: Color(0xFF7C4DFF), opacity: 0.0),
          RadialStop.at(0.25, color: Color(0xFFFFC857), opacity: 0.8),
          RadialStop.at(0.10, color: Color(0xFFFF4D8D), opacity: 0.9),
        ],
      );

      // All six stops survive, sorted ascending by position.
      expect(g.stops, [0.0, 0.10, 0.25, 0.50, 0.75, 1.0]);
      expect(g.colors.length, 6);
      // Opacity is applied per stop, independently.
      expect(g.colors.last.a, 0.0);
      expect(g.colors[1].a, closeTo(0.9, 1e-6));
      // Still produces a valid shader with many stops.
      expect(g.createShader(const Rect.fromLTWH(0, 0, 100, 100)), isNotNull);
    });
  });

  group('RadialGradientBox', () {
    testWidgets('renders a circle gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: RadialGradientBox(
              width: 100,
              height: 100,
              colorStops: [
                RadialStop.start(color: Color(0xFF00FFFF)),
                RadialStop.end(color: Color(0xFF00FFFF), opacity: 0),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(RadialGradientBox), findsOneWidget);
    });

    testWidgets('adds blur and backdrop blur layers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: RadialGradientBox(
              width: 100,
              height: 100,
              blur: 10,
              backdropBlur: 8,
              colorStops: [
                RadialStop.start(color: Color(0xFF00FFFF)),
                RadialStop.end(color: Color(0xFF00FFFF), opacity: 0),
              ],
              child: Text('hi'),
            ),
          ),
        ),
      );
      expect(find.byType(ImageFiltered), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.text('hi'), findsOneWidget);
    });

    test('asserts borderRadius only with rectangle shape', () {
      expect(
        () => RadialGradientBox(
          shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(8),
          colorStops: const [
            RadialStop.start(color: Color(0xFF000000)),
            RadialStop.end(color: Color(0xFF000000), opacity: 0),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

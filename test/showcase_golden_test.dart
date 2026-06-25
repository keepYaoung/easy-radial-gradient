import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders the showcase used in the README.
///
/// Regenerate the image with:
///
/// ```sh
/// flutter test --update-goldens test/showcase_golden_test.dart
/// ```
void main() {
  testWidgets('showcase renders to README image', (tester) async {
    tester.view.physicalSize = const Size(2000, 540);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const _Showcase());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_Showcase),
      matchesGoldenFile('../doc/images/showcase.png'),
    );
  });
}

class _Showcase extends StatelessWidget {
  const _Showcase();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF0E0B1A)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. One-line glow.
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: EasyRadialGradient.glow(const Color(0xFFFFC857)),
                ),
              ),

              // 2. Multi-stop gradient (6 stops).
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: EasyRadialGradient(
                    colorStops: const [
                      RadialStop.start(color: Color(0xFFFF4D8D)),
                      RadialStop.at(0.25, color: Color(0xFFFFC857)),
                      RadialStop.at(0.50, color: Color(0xFF4DD0FF)),
                      RadialStop.at(0.75, color: Color(0xFF7C4DFF)),
                      RadialStop.end(color: Color(0xFF7C4DFF), opacity: 0.0),
                    ],
                  ),
                ),
              ),

              // 3. Gaussian-blurred glow.
              const RadialGradientBox(
                width: 180,
                height: 180,
                blur: 26,
                colorStops: [
                  RadialStop.start(color: Color(0xFF4DFFB0)),
                  RadialStop.end(color: Color(0xFF4DFFB0), opacity: 0.0),
                ],
              ),

              // 4. Frosted-glass card (backdrop blur) over colored blobs.
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(left: 0, top: 14, child: _blob(0xFFFF4D8D)),
                    Positioned(right: 0, bottom: 14, child: _blob(0xFF4DD0FF)),
                    const RadialGradientBox(
                      width: 180,
                      height: 150,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      backdropBlur: 18,
                      colorStops: [
                        RadialStop.start(color: Color(0xFFFFFFFF), opacity: 0.35),
                        RadialStop.end(color: Color(0xFFFFFFFF), opacity: 0.08),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _blob(int color) => Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: EasyRadialGradient.glow(Color(color)),
        ),
      );
}

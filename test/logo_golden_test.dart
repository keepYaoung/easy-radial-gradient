import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders the square logo used as the pub.dev thumbnail (first screenshot):
/// a "liquid glass" frosted card (backdrop blur) floating over colored blobs.
///
/// Regenerate with:
///
/// ```sh
/// flutter test --update-goldens test/logo_golden_test.dart
/// ```
void main() {
  testWidgets('logo renders to thumbnail image', (tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const _Logo());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_Logo),
      matchesGoldenFile('../doc/images/logo.png'),
    );
  });
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF0E0B1A)),
        child: Center(
          child: SizedBox(
            width: 600,
            height: 600,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vivid, fairly solid blobs that straddle the glass edges,
                // so the frosted panel reads against the sharp content.
                const Positioned(
                  left: 40,
                  top: 150,
                  child: _Blob(0xFFFF2D7E, 250),
                ),
                const Positioned(
                  right: 40,
                  bottom: 110,
                  child: _Blob(0xFF22C3FF, 270),
                ),
                const Positioned(
                  right: 130,
                  top: 50,
                  child: _Blob(0xFFFFB020, 180),
                ),

                // Liquid-glass frosted card (backdrop blur) — smaller than the
                // frame so a margin of sharp blobs surrounds it.
                RadialGradientBox(
                  width: 330,
                  height: 330,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(82),
                  backdropBlur: 24,
                  colorStops: const [
                    RadialStop.start(color: Color(0xFFFFFFFF), opacity: 0.34),
                    RadialStop.at(
                      0.65,
                      color: Color(0xFFFFFFFF),
                      opacity: 0.10,
                    ),
                    RadialStop.end(color: Color(0xFFFFFFFF), opacity: 0.04),
                  ],
                ),

                // Subtle glass rim highlight.
                Container(
                  width: 330,
                  height: 330,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(82),
                    border: Border.all(
                      color: const Color(0x33FFFFFF),
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(this.color, this.size);

  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: EasyRadialGradient(
          colorStops: [
            RadialStop.start(color: Color(color)),
            RadialStop.at(0.6, color: Color(color)),
            RadialStop.end(color: Color(color), opacity: 0.0),
          ],
        ),
      ),
    );
  }
}

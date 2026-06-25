import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_radial_gradient',
      theme: ThemeData.dark(useMaterial3: true),
      home: const _Demo(),
    );
  }
}

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1A),
      appBar: AppBar(title: const Text('easy_radial_gradient')),
      body: Stack(
        children: [
          // Some colorful content to sit *behind* the frosted card.
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: EasyRadialGradient(
                  colorStops: const [
                    RadialStop.start(color: Color(0xFFFF4D8D)),
                    RadialStop.end(color: Color(0xFFFF4D8D), opacity: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: EasyRadialGradient(
                  colorStops: const [
                    RadialStop.start(color: Color(0xFF4DD0FF)),
                    RadialStop.end(color: Color(0xFF4DD0FF), opacity: 0),
                  ],
                ),
              ),
            ),
          ),

          // Foreground: gallery of the three core use cases.
          Center(
            child: Wrap(
              spacing: 28,
              runSpacing: 28,
              alignment: WrapAlignment.center,
              children: [
                // 1. Plain glow via the drop-in gradient.
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: EasyRadialGradient.glow(const Color(0xFFFFC857)),
                  ),
                ),

                // 2. Gaussian-blurred glow behind a crisp child.
                RadialGradientBox(
                  width: 160,
                  height: 160,
                  blur: 20,
                  colorStops: const [
                    RadialStop.start(color: Color(0xFF7C4DFF)),
                    RadialStop.end(color: Color(0xFF7C4DFF), opacity: 0),
                  ],
                  child: const Text(
                    'blur',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // 3. Frosted-glass card over the background blobs.
                RadialGradientBox(
                  width: 200,
                  height: 160,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(24),
                  backdropBlur: 18,
                  colorStops: const [
                    RadialStop.start(color: Color(0xFFFFFFFF), opacity: 0.30),
                    RadialStop.end(color: Color(0xFFFFFFFF), opacity: 0.05),
                  ],
                  child: const Text('frosted card'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

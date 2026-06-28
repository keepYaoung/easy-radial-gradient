import 'package:easy_radial_gradient/easy_radial_gradient.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_radial_gradient',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF0E0B1A)),
      home: const PlaygroundPage(),
    );
  }
}

/// A color preset: a label and its list of [RadialStop]s.
class _Preset {
  const _Preset(this.label, this.stops);
  final String label;
  final List<RadialStop> stops;
}

const _presets = <_Preset>[
  _Preset('Sunset', [
    RadialStop.start(color: Color(0xFFFFF1C2)),
    RadialStop.at(0.35, color: Color(0xFFFFC857)),
    RadialStop.at(0.7, color: Color(0xFFFF4D8D)),
    RadialStop.end(color: Color(0xFFFF4D8D), opacity: 0.0),
  ]),
  _Preset('Ocean', [
    RadialStop.start(color: Color(0xFF8AF0FF)),
    RadialStop.at(0.5, color: Color(0xFF4DD0FF)),
    RadialStop.at(0.8, color: Color(0xFF7C4DFF)),
    RadialStop.end(color: Color(0xFF7C4DFF), opacity: 0.0),
  ]),
  _Preset('Frost (glass)', [
    RadialStop.start(color: Color(0xFFFFFFFF), opacity: 0.34),
    RadialStop.at(0.65, color: Color(0xFFFFFFFF), opacity: 0.12),
    RadialStop.end(color: Color(0xFFFFFFFF), opacity: 0.04),
  ]),
];

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  double _blur = 0;
  double _backdropBlur = 14;
  double _radius = 0.5;
  double _corner = 36;
  bool _isCircle = false;
  int _presetIndex = 2; // Frost — shows backdrop blur nicely.

  @override
  Widget build(BuildContext context) {
    final preset = _presets[_presetIndex];

    final box = RadialGradientBox(
      width: 240,
      height: _isCircle ? 240 : 200,
      radius: _radius,
      blur: _blur,
      backdropBlur: _backdropBlur,
      shape: _isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _isCircle ? null : BorderRadius.circular(_corner),
      colorStops: preset.stops,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('easy_radial_gradient'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live preview, with colorful blobs behind so backdrop blur shows.
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    left: 36,
                    top: 24,
                    child: _Blob(0xFFFF2D7E, 200),
                  ),
                  const Positioned(
                    right: 28,
                    bottom: 18,
                    child: _Blob(0xFF22C3FF, 220),
                  ),
                  const Positioned(
                    right: 70,
                    top: 30,
                    child: _Blob(0xFFFFB020, 150),
                  ),
                  box,
                ],
              ),
            ),

            // Controls.
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF161427),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var i = 0; i < _presets.length; i++)
                        ChoiceChip(
                          label: Text(_presets[i].label),
                          selected: _presetIndex == i,
                          onSelected: (_) => setState(() => _presetIndex = i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Shape'),
                      const SizedBox(width: 12),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('Circle')),
                          ButtonSegment(value: false, label: Text('Rounded')),
                        ],
                        selected: {_isCircle},
                        onSelectionChanged: (s) =>
                            setState(() => _isCircle = s.first),
                      ),
                    ],
                  ),
                  _slider('blur', _blur, 0, 40, (v) => _blur = v),
                  _slider(
                    'backdropBlur',
                    _backdropBlur,
                    0,
                    40,
                    (v) => _backdropBlur = v,
                  ),
                  _slider('radius', _radius, 0.1, 1.0, (v) => _radius = v),
                  if (!_isCircle)
                    _slider('corner', _corner, 0, 100, (v) => _corner = v),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 104,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: (v) => setState(() => onChanged(v)),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            value.toStringAsFixed(max <= 1 ? 2 : 0),
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
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

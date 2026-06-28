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
      home: const LiveEditorPage(),
    );
  }
}

/// A tiny "edit the numbers in the code" demo: a single radial-gradient circle
/// whose source is shown as an editable snippet. Only the numeric literals are
/// editable (highlighted in amber); everything updates live.
class LiveEditorPage extends StatefulWidget {
  const LiveEditorPage({super.key});

  @override
  State<LiveEditorPage> createState() => _LiveEditorPageState();
}

class _LiveEditorPageState extends State<LiveEditorPage> {
  double _radius = 0.5;
  double _blur = 0;
  double _midPos = 0.55;
  double _midOpacity = 1.0;
  double _endOpacity = 0.0;

  static const _c0 = Color(0xFFFFC857); // start  (gold)
  static const _c1 = Color(0xFFFF4D8D); // middle (pink)
  static const _c2 = Color(0xFF7C4DFF); // end    (violet)

  @override
  Widget build(BuildContext context) {
    final preview = Center(
      child: RadialGradientBox(
        width: 260,
        height: 260,
        radius: _radius,
        blur: _blur,
        colorStops: [
          RadialStop.start(color: _c0),
          RadialStop.at(_midPos, color: _c1, opacity: _midOpacity),
          RadialStop.end(color: _c2, opacity: _endOpacity),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('easy_radial_gradient'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: preview),
                  Expanded(child: _editorPanel()),
                ],
              );
            }
            return Column(
              children: [
                Expanded(child: preview),
                _editorPanel(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _editorPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF161427),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit, size: 15, color: Color(0xFFFFD479)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Edit the highlighted numbers',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _codeBlock(),
          ),
        ],
      ),
    );
  }

  // --- editable code snippet ---------------------------------------------

  static const _mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    height: 1.7,
    color: Color(0xFFC9D1D9),
  );

  static const _comment = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12.5,
    height: 1.7,
    color: Color(0xFF6A9955), // comment green
  );

  Widget _codeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RadialGradientBox(', style: _mono),
        const Text('  shape: BoxShape.circle,', style: _mono),
        _line([
          const Text('  radius: ', style: _mono),
          _num(_radius, 0, 1.5, 2, (v) => _radius = v),
          const Text(',', style: _mono),
        ]),
        _line([
          const Text('  blur: ', style: _mono),
          _num(_blur, 0, 40, 0, (v) => _blur = v),
          const Text(',', style: _mono),
        ]),
        const Text('  colorStops: [', style: _mono),
        _codeColorLine('    RadialStop.start(color: ', _c0, '),'),
        _line([
          const Text('    RadialStop.at(', style: _mono),
          _num(_midPos, 0, 1, 2, (v) => _midPos = v),
          const Text(', color: ', style: _mono),
          _swatch(_c1),
          const Text(', opacity: ', style: _mono),
          _num(_midOpacity, 0, 1, 2, (v) => _midOpacity = v),
          const Text('),', style: _mono),
        ]),
        _line([
          const Text('    RadialStop.end(color: ', style: _mono),
          _swatch(_c2),
          const Text(', opacity: ', style: _mono),
          _num(_endOpacity, 0, 1, 2, (v) => _endOpacity = v),
          const Text('),', style: _mono),
        ]),
        const Text('  ],', style: _mono),
        const Text(')', style: _mono),
        const SizedBox(height: 16),
        const Text(
          '// radius      -> how far the gradient spreads (0 to 1.5)',
          style: _comment,
        ),
        const Text(
          '// blur        -> gaussian softening of the whole circle',
          style: _comment,
        ),
        const Text(
          '// .at(pos)    -> position of the middle color (0 to 1)',
          style: _comment,
        ),
        const Text(
          '// opacity     -> per-stop alpha: 1 = solid, 0 = clear',
          style: _comment,
        ),
        const Text(
          '// end opacity -> 0 fades out at the edge = a glow',
          style: _comment,
        ),
      ],
    );
  }

  Widget _codeColorLine(String prefix, Color color, String suffix) {
    return _line([
      Text(prefix, style: _mono),
      _swatch(color),
      Text(suffix, style: _mono),
    ]);
  }

  Widget _line(List<Widget> children) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  /// A non-editable color literal with a small swatch, e.g. `Color(0xFFFF4D8D)`.
  Widget _swatch(Color color) {
    final hex = color
        .toARGB32()
        .toRadixString(16)
        .toUpperCase()
        .padLeft(8, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          'Color(0x$hex)',
          style: _mono.copyWith(color: const Color(0xFF79C0FF)),
        ),
      ],
    );
  }

  Widget _num(
    double value,
    double min,
    double max,
    int decimals,
    ValueChanged<double> onChanged,
  ) {
    return _NumberField(
      value: value,
      min: min,
      max: max,
      decimals: decimals,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }
}

/// An inline, editable numeric literal rendered in amber to signal "editable".
class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.value,
    required this.min,
    required this.max,
    required this.decimals,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int decimals;
  final ValueChanged<double> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value.toStringAsFixed(widget.decimals),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.decimals == 0 ? 34 : 48,
      child: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        cursorColor: const Color(0xFFFFD479),
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFFD479),
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 2),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x55FFD479)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFD479)),
          ),
        ),
        onChanged: (text) {
          final parsed = double.tryParse(text);
          if (parsed == null) return;
          widget.onChanged(parsed.clamp(widget.min, widget.max));
        },
      ),
    );
  }
}

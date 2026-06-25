## 0.0.1

Initial release.

* `RadialStop` — a design-tool-style gradient stop bundling position, color and
  opacity, with `.start` / `.at` / `.end` / `.transparent` named constructors
  for readable inline stops.
* `EasyRadialGradient` — a drop-in `RadialGradient` built from a `colorStops`
  list, with auto-sorted stops, `copyWith`, and an `EasyRadialGradient.glow`
  factory.
* `RadialGradientBox` — a widget that paints the gradient with optional Gaussian
  `blur` (gradient only, child stays sharp) and frosted-glass `backdropBlur`,
  clipped to a circle or rounded rectangle.

## 1.0.1

* Add a package logo and a showcase image as pub.dev `screenshots` — the logo
  now appears as the package thumbnail. No code changes.

## 1.0.0

First stable release. No API changes from `0.0.1` — the public API
(`RadialStop`, `EasyRadialGradient`, `RadialGradientBox`) is now considered
stable, with bilingual (English/Korean) dartdoc and a 160/160 pana score.

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

/// Design-tool-style radial gradients for Flutter.
///
/// Instead of vanilla Flutter's parallel `colors` / `stops` lists, describe
/// each stop as a single [RadialStop] (position + color + opacity) — the same
/// mental model as Figma, Sketch and Adobe XD. Comes with an optional Gaussian
/// blur and frosted-glass backdrop blur via [RadialGradientBox].
///
/// Flutter용 디자인 툴 스타일 라디얼 그라디언트입니다. 기본 Flutter의 `colors`
/// / `stops` 병렬 리스트 대신, 각 스톱을 하나의 [RadialStop](위치 + 색 +
/// 투명도)으로 기술합니다 — Figma, Sketch, Adobe XD와 동일한 사고방식입니다.
/// [RadialGradientBox]를 통해 가우시안 블러와 프로스티드 글래스 백드롭 블러도
/// 선택적으로 제공합니다.
library;

export 'src/easy_radial_gradient.dart';
export 'src/radial_gradient_box.dart';
export 'src/radial_stop.dart';

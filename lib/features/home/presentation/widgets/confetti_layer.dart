import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flick_tv/core/constants/app_assets.dart';

/// Plays confetti Lottie once when the wallet icon appears; hidden before brand text.
class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({
    required this.opacity,
    required this.walletReveal,
    required this.brandReveal,
    super.key,
  });

  /// Layer fade driven by parent intro timeline.
  final double opacity;

  /// Wallet icon visibility (0 → 1).
  final double walletReveal;

  /// Brand text visibility — confetti hides once this starts.
  final double brandReveal;

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<ConfettiLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool _compositionLoaded = false;
  bool _hasPlayed = false;

  bool get _shouldShowLayer =>
      widget.opacity > 0 &&
      widget.brandReveal < 0.02 &&
      (widget.walletReveal > 0 || _hasPlayed);

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(ConfettiLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybePlayOnce();
  }

  void _maybePlayOnce() {
    if (!_compositionLoaded || _hasPlayed || widget.brandReveal >= 0.02) {
      return;
    }

    if (widget.walletReveal > 0.05) {
      _hasPlayed = true;
      _lottieController.forward();
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowLayer) return const SizedBox.shrink();

    return IgnorePointer(
      child: Opacity(
        opacity: widget.opacity.clamp(0, 1),
        child: Lottie.asset(
          AppAssets.confettiLottie,
          controller: _lottieController,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          repeat: false,
          onLoaded: (composition) {
            _lottieController.duration = composition.duration;
            setState(() => _compositionLoaded = true);
            _maybePlayOnce();
          },
        ),
      ),
    );
  }
}

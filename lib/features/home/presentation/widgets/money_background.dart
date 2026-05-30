import 'package:flutter/material.dart';
import 'package:flick_tv/core/theme/app_colors.dart';

class MoneyBackground extends StatelessWidget {
  const MoneyBackground({required this.patternOpacity, super.key});

  final double patternOpacity;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Opacity(
        opacity: patternOpacity.clamp(0, 1),
        child: const SizedBox.expand(
          child: CustomPaint(painter: _TopGlowDotPainter()),
        ),
      ),
    );
  }
}

class _TopGlowDotPainter extends CustomPainter {
  const _TopGlowDotPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gradientRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.5);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.topGlow.withValues(alpha: 0.85),
        AppColors.background.withValues(alpha: 0),
      ],
      stops: const [0, 0.45],
    );
    canvas.drawRect(
      gradientRect,
      Paint()..shader = gradient.createShader(gradientRect),
    );

    const spacing = 14.0;
    const dotRadius = 1.2;
    final maxY = size.height * 0.42;

    for (var y = 0.0; y < maxY; y += spacing) {
      final fade = 1 - (y / maxY);
      final dotPaint = Paint()
        ..color = AppColors.brandRedLight.withValues(alpha: 0.28 * fade);
      for (var x = 0.0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TopGlowDotPainter oldDelegate) => false;
}

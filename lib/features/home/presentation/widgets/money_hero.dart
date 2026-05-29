import 'package:flutter/material.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/features/home/presentation/widgets/wallet_icon.dart';

class MoneyHero extends StatelessWidget {
  const MoneyHero({
    required this.brandName,
    required this.featureTitle,
    required this.walletOpacity,
    required this.walletScale,
    required this.brandOpacity,
    required this.titleOpacity,
    required this.titleSlide,
    super.key,
  });

  final String brandName;
  final String featureTitle;
  final double walletOpacity;
  final double walletScale;
  final double brandOpacity;
  final double titleOpacity;
  final double titleSlide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          Opacity(
            opacity: walletOpacity.clamp(0, 1),
            child: Transform.scale(
              scale: walletScale.clamp(0, 1.2),
              child: const WalletIcon(),
            ),
          ),
          const SizedBox(height: 20),
          Opacity(
            opacity: brandOpacity.clamp(0, 1),
            child: Text(
              brandName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: titleOpacity.clamp(0, 1),
            child: Transform.translate(
              offset: Offset(0, titleSlide),
              child: Text(
                featureTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
              ),
            ),
          ),
        ],
    );
  }
}

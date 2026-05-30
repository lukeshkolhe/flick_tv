import 'package:flutter/material.dart';
import 'package:flick_tv/core/constants/app_strings.dart';
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
          child: _BrandTitle(brandName: brandName),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: titleOpacity.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, titleSlide),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FeatureTitle(title: featureTitle),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.brandRedLight,
                        AppColors.brandRedDark,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureTitle extends StatelessWidget {
  const _FeatureTitle({required this.title});

  final String title;

  static const _titleStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    height: 1.1,
  );

  static const _accentStyle = TextStyle(
    color: AppColors.brandRed,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    height: 1.1,
  );

  @override
  Widget build(BuildContext context) {
    final dramaIndex = title.indexOf(AppStrings.featureTitleAccentSuffix);
    if (dramaIndex > 0) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title.substring(0, dramaIndex),
                style: _titleStyle,
              ),
              TextSpan(
                text: title.substring(dramaIndex),
                style: _accentStyle,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(title, textAlign: TextAlign.center, style: _titleStyle),
    );
  }
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle({required this.brandName});

  final String brandName;

  @override
  Widget build(BuildContext context) {
    final tvIndex =
        brandName.toUpperCase().lastIndexOf(AppStrings.brandTvAccent);
    if (tvIndex <= 0) {
      return Text(
        brandName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      );
    }

    final prefix = brandName.substring(0, tvIndex).trimRight();
    const brandStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
    const accentStyle = TextStyle(
      color: AppColors.brandRed,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.4,
    );

    return Text.rich(
      TextSpan(
        children: [
          if (prefix.isNotEmpty) TextSpan(text: '$prefix ', style: brandStyle),
          TextSpan(text: AppStrings.brandTvAccent, style: accentStyle),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/core/widgets/app_svg_asset.dart';
import 'package:flick_tv/features/home/domain/entities/feature_highlight.dart';

/// Benefit option tile for the Flick TV micro drama home screen.
class FeatureCard extends StatelessWidget {
  const FeatureCard({required this.highlight, super.key});

  final FeatureHighlight highlight;

  static const _iconSize = 56.0;
  static const _iconRadius = 12.0;
  static const _cardRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _iconSize,
            height: _iconSize,
            decoration: BoxDecoration(
              color: AppColors.featureIconBackground,
              borderRadius: BorderRadius.circular(_iconRadius),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: AppSvgAsset(
                assetPath: highlight.iconAsset,
                width: _iconSize - 12,
                height: _iconSize - 12,
                semanticLabel: highlight.title,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    highlight.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    highlight.subtitle,
                    style: const TextStyle(
                      color: AppColors.featureSubtitle,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

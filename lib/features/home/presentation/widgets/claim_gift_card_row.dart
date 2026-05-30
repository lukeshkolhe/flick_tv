import 'package:flutter/material.dart';
import 'package:flick_tv/core/constants/app_assets.dart';
import 'package:flick_tv/core/constants/app_strings.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/core/widgets/app_svg_asset.dart';

/// Compact navigation row for gift credit redemption — distinct from [FeatureCard] tiles.
class ClaimGiftCardRow extends StatelessWidget {
  const ClaimGiftCardRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  static const _cardRadius = 18.0;
  static const _thumbSize = 44.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: _thumbSize,
                  height: _thumbSize,
                  child: const AppSvgAsset(
                    assetPath: AppAssets.giftCardThumb,
                    fit: BoxFit.cover,
                    semanticLabel: AppStrings.giftCredits,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.featureSubtitle,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

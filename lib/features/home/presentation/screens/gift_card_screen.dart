import 'package:flutter/material.dart';
import 'package:flick_tv/core/constants/app_assets.dart';
import 'package:flick_tv/core/constants/app_strings.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/core/widgets/app_svg_asset.dart';
import 'package:flick_tv/features/home/presentation/widgets/home_sub_screen_scaffold.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

  static const String routeName = '/gift-card';

  @override
  Widget build(BuildContext context) {
    return HomeSubScreenScaffold(
      title: AppStrings.redeemGiftCredits,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppSvgAsset(
                assetPath: AppAssets.giftBox,
                width: 72,
                height: 72,
                semanticLabel: AppStrings.giftCredits,
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.redeemGiftCreditsHeading,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.redeemGiftCreditsBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

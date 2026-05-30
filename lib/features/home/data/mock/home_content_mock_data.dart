import 'package:flick_tv/core/constants/app_assets.dart';
import 'package:flick_tv/core/constants/app_strings.dart';

/// Shared mock payloads — used by local cache and mock remote API.
abstract final class HomeContentMockData {
  static Map<String, dynamic> get homeJson => {
        'brand_name': AppStrings.brandName,
        'feature_title': AppStrings.featureTitle,
        'footer_watermark': AppStrings.footerWatermark,
        'add_money_label': AppStrings.addFlickCredits,
        'gift_card_title': AppStrings.redeemGiftCredits,
        'gift_card_subtitle': AppStrings.giftCreditsSubtitle,
        'features': [
          {
            'id': 'one_tap_episodes',
            'title': AppStrings.oneTapEpisodesTitle,
            'subtitle': AppStrings.oneTapEpisodesSubtitle,
            'icon_asset': AppAssets.featureSingleTap,
          },
          {
            'id': 'zero_buffering',
            'title': AppStrings.zeroBufferingTitle,
            'subtitle': AppStrings.zeroBufferingSubtitle,
            'icon_asset': AppAssets.featureInstant,
          },
          {
            'id': 'instant_unlocks',
            'title': AppStrings.instantUnlocksTitle,
            'subtitle': AppStrings.instantUnlocksSubtitle,
            'icon_asset': AppAssets.featureRewards,
          },
        ],
      };
}

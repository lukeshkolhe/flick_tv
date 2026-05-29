import 'package:flick_tv/core/constants/app_assets.dart';

/// Shared mock payloads — used by local cache and mock remote API.
abstract final class HomeContentMockData {
  static Map<String, dynamic> get homeJson => {
        'brand_name': 'Flick TV',
        'feature_title': 'MONEY',
        'footer_watermark': 'Enjoy Seamless one tap payments',
        'add_money_label': 'Add Money',
        'gift_card_title': 'Claim Gift Card',
        'gift_card_subtitle':
            'Enter gift card details to claim your gift card',
        'features': [
          {
            'id': 'single_tap',
            'title': 'Single tap payments',
            'subtitle':
                'Enjoy seamless payments without the wait for OTPs',
            'icon_asset': AppAssets.featureSingleTap,
          },
          {
            'id': 'zero_failures',
            'title': 'Zero failures',
            'subtitle':
                'Zero payment failures ensure you never miss an order',
            'icon_asset': AppAssets.featureInstant,
          },
          {
            'id': 'realtime_refunds',
            'title': 'Real-time refunds',
            'subtitle':
                'No need to wait for refunds. Flick TV Money refunds are instant!',
            'icon_asset': AppAssets.featureRewards,
          },
        ],
      };
}

import 'package:flick_tv/features/home/data/models/feature_highlight_model.dart';
import 'package:flick_tv/features/home/domain/entities/home_content.dart';

class HomeContentModel {
  const HomeContentModel({
    required this.brandName,
    required this.featureTitle,
    required this.features,
    required this.footerWatermark,
    required this.addMoneyLabel,
    required this.giftCardTitle,
    required this.giftCardSubtitle,
  });

  factory HomeContentModel.fromJson(Map<String, dynamic> json) {
    final featuresJson = json['features'] as List<dynamic>;
    return HomeContentModel(
      brandName: json['brand_name'] as String,
      featureTitle: json['feature_title'] as String,
      features: featuresJson
          .map(
            (item) => FeatureHighlightModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      footerWatermark: json['footer_watermark'] as String,
      addMoneyLabel: json['add_money_label'] as String,
      giftCardTitle: json['gift_card_title'] as String,
      giftCardSubtitle: json['gift_card_subtitle'] as String,
    );
  }

  final String brandName;
  final String featureTitle;
  final List<FeatureHighlightModel> features;
  final String footerWatermark;
  final String addMoneyLabel;
  final String giftCardTitle;
  final String giftCardSubtitle;

  HomeContent toEntity() {
    return HomeContent(
      brandName: brandName,
      featureTitle: featureTitle,
      features: features.map((model) => model.toEntity()).toList(),
      footerWatermark: footerWatermark,
      addMoneyLabel: addMoneyLabel,
      giftCardTitle: giftCardTitle,
      giftCardSubtitle: giftCardSubtitle,
    );
  }
}

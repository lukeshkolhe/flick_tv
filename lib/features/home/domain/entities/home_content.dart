import 'package:equatable/equatable.dart';
import 'package:flick_tv/features/home/domain/entities/feature_highlight.dart';

class HomeContent extends Equatable {
  const HomeContent({
    required this.brandName,
    required this.featureTitle,
    required this.features,
    required this.footerWatermark,
    required this.addMoneyLabel,
    required this.giftCardTitle,
    required this.giftCardSubtitle,
  });

  final String brandName;
  final String featureTitle;
  final List<FeatureHighlight> features;
  final String footerWatermark;
  final String addMoneyLabel;
  final String giftCardTitle;
  final String giftCardSubtitle;

  @override
  List<Object?> get props => [
        brandName,
        featureTitle,
        features,
        footerWatermark,
        addMoneyLabel,
        giftCardTitle,
        giftCardSubtitle,
      ];
}

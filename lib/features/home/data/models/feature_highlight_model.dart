import 'package:flick_tv/features/home/domain/entities/feature_highlight.dart';

class FeatureHighlightModel {
  const FeatureHighlightModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });

  factory FeatureHighlightModel.fromJson(Map<String, dynamic> json) {
    return FeatureHighlightModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconAsset: json['icon_asset'] as String,
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String iconAsset;

  FeatureHighlight toEntity() {
    return FeatureHighlight(
      id: id,
      title: title,
      subtitle: subtitle,
      iconAsset: iconAsset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon_asset': iconAsset,
    };
  }
}

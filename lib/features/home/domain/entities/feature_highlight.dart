import 'package:equatable/equatable.dart';

class FeatureHighlight extends Equatable {
  const FeatureHighlight({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconAsset;

  @override
  List<Object?> get props => [id, title, subtitle, iconAsset];
}

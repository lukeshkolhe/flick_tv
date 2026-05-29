import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders an SVG from the asset bundle.
class AppSvgAsset extends StatelessWidget {
  const AppSvgAsset({
    required this.assetPath,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final picture = SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
    );

    if (semanticLabel == null) return picture;

    return Semantics(
      label: semanticLabel,
      child: picture,
    );
  }
}

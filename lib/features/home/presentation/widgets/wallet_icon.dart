import 'package:flutter/material.dart';
import 'package:flick_tv/core/constants/app_assets.dart';
import 'package:flick_tv/core/constants/app_strings.dart';
import 'package:flick_tv/core/widgets/app_svg_asset.dart';

class WalletIcon extends StatelessWidget {
  const WalletIcon({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.12,
      child: AppSvgAsset(
        assetPath: AppAssets.wallet,
        width: size,
        height: size * 0.8,
        semanticLabel: AppStrings.wallet,
      ),
    );
  }
}

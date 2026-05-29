import 'package:flutter/material.dart';
import 'package:flick_tv/core/widgets/circle_icon_button.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    required this.settingsOpacity,
    required this.onBack,
    required this.onSettings,
    super.key,
  });

  final double settingsOpacity;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            icon: Icons.arrow_back_ios_new,
            semanticLabel: 'Go back',
            onPressed: onBack,
          ),
          Opacity(
            opacity: settingsOpacity.clamp(0, 1),
            child: CircleIconButton(
              icon: Icons.settings_outlined,
              semanticLabel: 'Settings',
              onPressed: onSettings,
            ),
          ),
        ],
      ),
    );
  }
}

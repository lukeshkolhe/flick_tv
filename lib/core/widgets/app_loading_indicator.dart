import 'package:flutter/material.dart';
import 'package:flick_tv/core/theme/app_colors.dart';

/// App-wide loading indicator — use from any feature screen.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColors.primaryCta);
  }
}

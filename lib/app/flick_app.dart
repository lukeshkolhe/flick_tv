import 'package:flutter/material.dart';
import 'package:flick_tv/app/router/app_router.dart';
import 'package:flick_tv/core/constants/app_constants.dart';
import 'package:flick_tv/core/theme/app_theme.dart';
import 'package:flick_tv/features/home/presentation/screens/home_screen.dart';

class FlickApp extends StatelessWidget {
  const FlickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: HomeScreen.routeName,
    );
  }
}

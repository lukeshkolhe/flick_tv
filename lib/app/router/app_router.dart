import 'package:flutter/material.dart';
import 'package:flick_tv/features/home/presentation/screens/add_money_screen.dart';
import 'package:flick_tv/features/home/presentation/screens/gift_card_screen.dart';
import 'package:flick_tv/features/home/presentation/screens/home_screen.dart';

abstract final class AppRoutes {
  static const String home = HomeScreen.routeName;
  static const String addMoney = AddMoneyScreen.routeName;
  static const String giftCard = GiftCardScreen.routeName;
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.home => _page(const HomeScreen(), settings),
      AppRoutes.addMoney => _page(const AddMoneyScreen(), settings),
      AppRoutes.giftCard => _page(const GiftCardScreen(), settings),
      _ => _page(const HomeScreen(), settings),
    };
  }

  static MaterialPageRoute<void> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

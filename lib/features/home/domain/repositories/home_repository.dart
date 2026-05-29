import 'package:flick_tv/features/home/domain/entities/home_content.dart';

abstract interface class HomeRepository {
  Future<HomeContent> getHomeContent();

  Future<void> onAddMoneyTapped();

  Future<void> onGiftCardTapped();
}

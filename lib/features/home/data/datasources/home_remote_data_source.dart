import 'package:flick_tv/core/constants/api_constants.dart';
import 'package:flick_tv/core/network/api_client.dart';
import 'package:flick_tv/features/home/data/models/home_content_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<HomeContentModel> getHomeContent();

  Future<void> submitAddMoney();

  Future<void> submitGiftCardClaim();
}

/// Fetches home content from API (mock or real via [ApiClient]).
final class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<HomeContentModel> getHomeContent() async {
    final json = await _apiClient.get(ApiConstants.homePath);
    return HomeContentModel.fromJson(json);
  }

  @override
  Future<void> submitAddMoney() async {
    await _apiClient.post(ApiConstants.addMoneyPath);
  }

  @override
  Future<void> submitGiftCardClaim() async {
    await _apiClient.post(ApiConstants.giftCardClaimPath);
  }
}

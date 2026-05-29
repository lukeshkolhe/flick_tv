import 'package:flick_tv/core/constants/app_constants.dart';
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
    final json = await _apiClient.get(AppConstants.homeContentPath);
    return HomeContentModel.fromJson(json);
  }

  @override
  Future<void> submitAddMoney() async {
    await _apiClient.post('${AppConstants.apiBasePath}/money/add');
  }

  @override
  Future<void> submitGiftCardClaim() async {
    await _apiClient.post('${AppConstants.apiBasePath}/gift-card/claim');
  }
}

import 'package:flick_tv/features/home/data/mock/home_content_mock_data.dart';
import 'package:flick_tv/features/home/data/models/home_content_model.dart';

abstract interface class HomeLocalDataSource {
  Future<HomeContentModel> getHomeContent();
}

/// Offline cache / bundled fallback when mock remote fails.
final class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeContentModel> getHomeContent() async {
    return HomeContentModel.fromJson(HomeContentMockData.homeJson);
  }
}

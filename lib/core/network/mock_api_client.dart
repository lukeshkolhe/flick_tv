import 'package:flick_tv/core/constants/app_constants.dart';
import 'package:flick_tv/core/error/exceptions.dart';
import 'package:flick_tv/core/network/api_client.dart';
import 'package:flick_tv/features/home/data/mock/home_content_mock_data.dart';

/// Simulates REST responses without a real server.
///
/// Swap the [ApiClient] binding to [HttpApiClient] when a backend exists.
final class MockApiClient implements ApiClient {
  MockApiClient({
    this.networkDelay = AppConstants.mockNetworkDelay,
    this.forceServerError = false,
  });

  final Duration networkDelay;
  final bool forceServerError;

  static final Map<String, Map<String, dynamic>> _routes = {
    AppConstants.homeContentPath: HomeContentMockData.homeJson,
  };

  @override
  Future<Map<String, dynamic>> get(String path) async {
    await Future<void>.delayed(networkDelay);

    if (forceServerError) {
      throw const ServerException('Mock API: simulated server error');
    }

    final body = _routes[path];
    if (body == null) {
      throw ServerException('Mock API: no route for $path');
    }

    return Map<String, dynamic>.from(body);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    await Future<void>.delayed(networkDelay);

    if (forceServerError) {
      throw const ServerException('Mock API: simulated server error');
    }

    return switch (path) {
      '${AppConstants.apiBasePath}/money/add' => {'success': true},
      '${AppConstants.apiBasePath}/gift-card/claim' => {'success': true},
      _ => throw ServerException('Mock API: no route for $path'),
    };
  }
}

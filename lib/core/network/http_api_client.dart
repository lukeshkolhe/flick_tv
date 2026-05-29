import 'package:flick_tv/core/network/api_client.dart';

/// Placeholder for a real backend — wire `package:http` or `dio` here.
final class HttpApiClient implements ApiClient {
  const HttpApiClient({required this.baseUrl});

  final String baseUrl;

  @override
  Future<Map<String, dynamic>> get(String path) {
    throw UnimplementedError(
      'HttpApiClient is not configured. Use MockApiClient or implement GET $baseUrl$path',
    );
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError(
      'HttpApiClient is not configured. Use MockApiClient or implement POST $baseUrl$path',
    );
  }
}

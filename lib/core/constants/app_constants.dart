/// App-wide constants (API URLs, timeouts, route names live in [AppRoutes]).
abstract final class AppConstants {
  static const String appName = 'Flick TV';
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Mock / production API base — prepend to paths in [ApiClient].
  static const String apiBasePath = '/api/v1';

  static const String homeContentPath = '$apiBasePath/home';

  /// Artificial latency for [MockApiClient] to mimic network.
  static const Duration mockNetworkDelay = Duration(milliseconds: 700);
}

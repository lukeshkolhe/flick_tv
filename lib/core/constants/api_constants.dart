/// API paths, endpoints, and network timing constants.
abstract final class ApiConstants {
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Mock / production API base — prepend to paths in [ApiClient].
  static const String basePath = '/api/v1';

  static const String homePath = '$basePath/home';
  static const String addMoneyPath = '$basePath/money/add';
  static const String giftCardClaimPath = '$basePath/gift-card/claim';

  /// Artificial latency for [MockApiClient] to mimic network.
  static const Duration mockNetworkDelay = Duration(milliseconds: 700);
}

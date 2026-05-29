/// How the app loads data until a real backend is available.
enum HomeDataSourceMode {
  /// In-memory / bundled JSON only (instant, offline).
  local,

  /// Simulated HTTP via [MockApiClient] (delay + JSON parsing).
  remoteMock,
}

class AppDataConfig {
  const AppDataConfig({
    this.homeDataSource = HomeDataSourceMode.remoteMock,
    this.fallbackToLocalOnRemoteError = true,
  });

  final HomeDataSourceMode homeDataSource;
  final bool fallbackToLocalOnRemoteError;
}

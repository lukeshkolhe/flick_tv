/// HTTP client abstraction — [MockApiClient] today, real HTTP client later.
abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path);

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  });
}

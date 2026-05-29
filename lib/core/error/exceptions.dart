import 'package:flick_tv/core/error/failures.dart';

/// Thrown by repositories when an operation fails at the domain level.
final class FailureException implements Exception {
  const FailureException(this.failure);

  final Failure failure;

  @override
  String toString() => 'FailureException: ${failure.message}';
}

/// Data-layer exceptions mapped to [Failure] in repositories.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

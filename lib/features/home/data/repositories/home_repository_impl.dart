import 'package:flick_tv/core/config/app_data_config.dart';
import 'package:flick_tv/core/error/exceptions.dart';
import 'package:flick_tv/core/error/failures.dart';
import 'package:flick_tv/features/home/data/datasources/home_local_data_source.dart';
import 'package:flick_tv/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flick_tv/features/home/domain/entities/home_content.dart';
import 'package:flick_tv/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required HomeRemoteDataSource remoteDataSource,
    required AppDataConfig config,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _config = config;

  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;
  final AppDataConfig _config;

  @override
  Future<HomeContent> getHomeContent() async {
    try {
      final model = switch (_config.homeDataSource) {
        HomeDataSourceMode.local => await _localDataSource.getHomeContent(),
        HomeDataSourceMode.remoteMock => await _remoteDataSource.getHomeContent(),
      };
      return model.toEntity();
    } on ServerException catch (e) {
      if (_shouldFallbackToLocal) {
        try {
          final cached = await _localDataSource.getHomeContent();
          return cached.toEntity();
        } catch (_) {
          throw FailureException(ServerFailure(e.message));
        }
      }
      throw FailureException(ServerFailure(e.message));
    } on CacheException catch (e) {
      throw FailureException(CacheFailure(e.message));
    } catch (_) {
      throw const FailureException(UnknownFailure());
    }
  }

  bool get _shouldFallbackToLocal =>
      _config.fallbackToLocalOnRemoteError &&
      _config.homeDataSource == HomeDataSourceMode.remoteMock;

  @override
  Future<void> onAddMoneyTapped() async {
    if (_config.homeDataSource == HomeDataSourceMode.remoteMock) {
      try {
        await _remoteDataSource.submitAddMoney();
        return;
      } on AppException {
        // No-op for mock analytics when offline.
      }
    }
  }

  @override
  Future<void> onGiftCardTapped() async {
    if (_config.homeDataSource == HomeDataSourceMode.remoteMock) {
      try {
        await _remoteDataSource.submitGiftCardClaim();
        return;
      } on AppException {
        // No-op for mock analytics when offline.
      }
    }
  }
}

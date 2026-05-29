import 'package:get_it/get_it.dart';
import 'package:flick_tv/core/config/app_data_config.dart';
import 'package:flick_tv/core/network/api_client.dart';
import 'package:flick_tv/core/network/mock_api_client.dart';
import 'package:flick_tv/features/home/data/datasources/home_local_data_source.dart';
import 'package:flick_tv/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flick_tv/features/home/data/repositories/home_repository_impl.dart';
import 'package:flick_tv/features/home/domain/repositories/home_repository.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

/// Switch [AppDataConfig.homeDataSource] to [HomeDataSourceMode.local] for
/// instant loads without mock network delay.
const AppDataConfig _dataConfig = AppDataConfig(
  homeDataSource: HomeDataSourceMode.remoteMock,
  fallbackToLocalOnRemoteError: true,
);

Future<void> configureDependencies() async {
  // Core
  sl.registerLazySingleton<AppDataConfig>(() => _dataConfig);
  sl.registerLazySingleton<ApiClient>(MockApiClient.new);

  // Home — data
  sl.registerLazySingleton<HomeLocalDataSource>(
    HomeLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );

  // Home — domain
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      config: sl(),
    ),
  );

  // Home — presentation
  sl.registerFactory(() => HomeBloc(homeRepository: sl()));
}

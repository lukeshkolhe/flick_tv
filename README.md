# flick_tv

Flick TV assignment — Flutter app with feature-first clean architecture.

## Run

```bash
flutter pub get
flutter run
```

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — layers, folders, Bloc, manual get_it DI, mock API

## Mock API (no backend)

Data flows through:

1. **`MockApiClient`** — fakes `GET /api/v1/home` with ~700ms delay and JSON from `HomeContentMockData`
2. **`HomeRemoteDataSource`** — parses the response like a real API
3. **`HomeLocalDataSource`** — offline fallback if the mock request fails

To use instant local data (no delay), change `AppDataConfig` in `lib/core/di/injection.dart`:

```dart
const AppDataConfig _dataConfig = AppDataConfig(
  homeDataSource: HomeDataSourceMode.local,
);
```

When a backend exists, register `HttpApiClient` instead of `MockApiClient` in `injection.dart`.

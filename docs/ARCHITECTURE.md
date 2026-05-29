# Flick TV — Architecture

Flutter app organized by **feature modules**. Each feature owns **presentation**, **domain**, and **data**. A feature is a product area (e.g. home, wallet, gift card)—not a single screen.

---

## Feature vs screen

| Concept | What it is | Example |
|---------|------------|---------|
| **Feature** | Business area + all layers for that area | `features/home/` |
| **Screen** | One route / full-page view inside a feature | `HomeScreen`, `HomeOnboardingScreen` |
| **Feature widget** | Reusable UI used on **one or more screens in the same feature** | `FeatureCard`, `MoneyHero` |
| **Global widget** | Reusable UI **across features** | `AppLoadingIndicator`, primary buttons |

- One feature → **many screens** (1 : N).
- One screen → **one primary route**, may compose many widgets.
- Feature widgets **must not** be imported by other features; use global widgets or move shared UI to `core/widgets/`.

---

## Layer overview (per feature)

```
features/<feature_name>/
├── presentation/     UI: screens, feature widgets, Bloc/Cubit
├── domain/           Entities + repository contracts (no Flutter)
└── data/             Models, data sources, repository implementations
```

App-wide code:

```
app/          MaterialApp, router
core/         theme, errors, DI, network, global widgets
```

**Dependency rule**

- `presentation` → `domain` (same feature)
- `data` → `domain` (same feature)
- `presentation` → `core` (theme, global widgets, DI)
- `presentation` must **not** import another feature’s `data/` or `presentation/`
- `domain` has no Flutter, Bloc, or JSON models

**No use case layer.** Bloc calls the feature’s repository contract directly.

---

## Folder structure

```
lib/
├── main.dart
├── app/
│   ├── flick_app.dart
│   └── router/app_router.dart
│
├── core/
│   ├── constants/
│   ├── di/injection.dart
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── widgets/                    # GLOBAL widgets (all features)
│       ├── widgets.dart              # barrel export
│       └── app_loading_indicator.dart
│
└── features/
    └── home/
        ├── domain/
        │   ├── entities/
        │   └── repositories/
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   └── repositories/
        └── presentation/
            ├── bloc/                 # feature state (may split per screen later)
            ├── screens/              # one file per route / screen
            │   └── home_screen.dart
            └── widgets/              # FEATURE widgets (reused across home screens)
                ├── home_widgets.dart # barrel export
                ├── money_hero.dart   # (add when building UI)
                └── feature_card.dart
```

Future features follow the same shape:

```
features/wallet/
  presentation/screens/...
  presentation/widgets/...
  domain/...
  data/...
```

---

## Presentation layer

### Screens (`presentation/screens/`)

- Full-page views tied to **routes**.
- Provide `BlocProvider` (or receive bloc from parent).
- Compose **feature widgets** and **global widgets**; keep layout thin.
- Naming: `HomeScreen`, `AddMoneyScreen` — suffix `Screen`.

### Feature widgets (`presentation/widgets/`)

- Stateless (or small stateful) components **owned by this feature**.
- Take **domain entities** or simple callbacks as parameters.
- Safe to use on **any screen inside the same feature**.
- Export via `<feature>_widgets.dart` for clean imports.

```dart
// features/home/presentation/widgets/feature_card.dart
class FeatureCard extends StatelessWidget {
  const FeatureCard({required this.highlight, super.key});
  final FeatureHighlight highlight;
  // ...
}
```

### Bloc (`presentation/bloc/`)

- Handles user events and calls **domain repositories**.
- Can be **one bloc per feature** or **one per screen** when state is unrelated—your choice as the feature grows.

### Global widgets (`core/widgets/`)

- Design-system pieces: loaders, buttons, app bars, error views.
- No feature-specific copy or entities.
- Export via `core/widgets/widgets.dart`.

**When to promote a widget to global**

- Used in **two or more features**, or
- Part of the app design system (buttons, typography wrappers).

**When to keep it in the feature**

- Uses feature entities, feature-specific layout, or product copy for that area only.

---

## Domain layer

| Piece | Role |
|-------|------|
| **Entities** | `HomeContent`, `FeatureHighlight` — pure Dart |
| **Repository (abstract)** | `HomeRepository` — what this feature needs from data |

Throws `FailureException` on failure (see below).

---

## Data layer

| Piece | Role |
|-------|------|
| **Model** | JSON / API DTO + `toEntity()` |
| **Data source** | Local cache + remote (mock or HTTP) |
| **Repository impl** | Implements domain contract; picks source via `AppDataConfig` |

### Mock API (no backend yet)

| File | Role |
|------|------|
| `HomeContentMockData` | Shared JSON for mock responses |
| `MockApiClient` | `GET /api/v1/home`, `POST` add-money / gift-card with ~700ms delay |
| `HttpApiClient` | Stub for a future real base URL |
| `AppDataConfig` | `HomeDataSourceMode.remoteMock` (default) or `.local` |

Repository falls back to `HomeLocalDataSource` if mock remote fails and `fallbackToLocalOnRemoteError` is true.

---

## Routing

`app/router/app_router.dart` maps **route name → Screen widget**.

Multiple routes can point to screens in the **same feature**:

```dart
case AppRoutes.home:
  return MaterialPageRoute(builder: (_) => const HomeScreen());
case AppRoutes.homeAddMoney:
  return MaterialPageRoute(builder: (_) => const AddMoneyScreen());
```

Both live under `features/home/presentation/screens/`.

---

## Data flow

```
HomeScreen
  → HomeBloc (presentation)
    → HomeRepository (domain)
      → HomeRepositoryImpl (data)
        → data sources → models → entities
  → HomeBloc emits state
  → Screen rebuilds using feature + global widgets
```

---

## Dependency injection

`core/di/injection.dart` — register by feature:

1. Data sources  
2. Repository (`HomeRepository` → `HomeRepositoryImpl`)  
3. Blocs (factory per screen or feature)

---

## Error handling

- Data: `ServerException`, `CacheException`
- Repository: `throw FailureException(failure)`
- Bloc: `catch (FailureException e)` → error state on screen

---

## Adding a new feature (checklist)

1. Create `features/<name>/domain|data|presentation`.
2. Add `presentation/screens/` and `presentation/widgets/`.
3. Register repository + bloc in `injection.dart`.
4. Add routes in `app_router.dart`.
5. Only add to `core/widgets/` if UI is truly cross-feature.

---

## Adding a new screen (existing feature)

1. Add `presentation/screens/<name>_screen.dart`.
2. Reuse widgets from `presentation/widgets/`.
3. Reuse or add bloc events/states; split bloc if state is unrelated.
4. Register route in `app_router.dart`.

---

## Implementation phases

| Phase | Deliverable |
|-------|-------------|
| **0** | Core + app shell + home domain/data |
| **1** | Home feature widgets + full `HomeScreen` UI + intro animation |
| **2** | Add Money + Gift Card screens + navigation — done |
| **3** | SVG assets via `flutter_svg` — done |
| **4** | Mock remote API (`MockApiClient`) — done |
| **5** | Real `HttpApiClient` when backend URL is available |
| **6** | New feature modules (`wallet`, etc.) |

---

## Conventions

- **Imports:** `package:flick_tv/...` only.
- **Files:** `snake_case`; types: `PascalCase`; suffixes `Screen`, `Bloc`, `Repository`.
- **Animation:** `AnimationController` only in screens or feature widgets—not in domain/data.

---

## Related docs

- [README.md](../README.md)

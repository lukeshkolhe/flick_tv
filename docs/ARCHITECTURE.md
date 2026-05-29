# Flick TV — Clean Architecture

This document defines how the app is structured: layers, dependencies, folders, and conventions. It pairs with [UI_HOME_SCREEN_PLAN.md](./UI_HOME_SCREEN_PLAN.md) for the first feature (home / money onboarding).

---

## Goals

- **Testable** — business rules live in domain, not in widgets.
- **Replaceable** — swap API, local DB, or mocks without touching UI.
- **Scalable** — new features add folders, not spaghetti in `main.dart`.
- **Assignment-friendly** — clear boundaries for reviews and incremental delivery.

---

## Layer overview

```
                    ┌─────────────────────────────────────┐
                    │           Presentation              │
                    │  (UI, State management, routing)   │
                    └─────────────────┬───────────────────┘
                                      │ uses
                    ┌─────────────────▼───────────────────┐
                    │              Domain                  │
                    │  Entities, Use cases, Repo contracts │
                    └─────────────────┬───────────────────┘
                                      │ implemented by
                    ┌─────────────────▼───────────────────┐
                    │               Data                   │
                    │  Models, Data sources, Repo impl     │
                    └─────────────────┬───────────────────┘
                                      │
                    ┌─────────────────▼───────────────────┐
                    │               Core                   │
                    │  DI, errors, theme, utils, network   │
                    └─────────────────────────────────────┘
```

**Dependency rule:** dependencies point **inward only**.

- `presentation` → `domain`
- `data` → `domain`
- `domain` → nothing feature-specific (only `core` types if shared)
- `presentation` must **not** import `data` implementations directly

---

## Recommended folder structure

Feature-first layout (one folder per feature, each with its own layers):

```
lib/
├── main.dart                          # bootstrap, runApp
├── app/
│   ├── flick_app.dart                 # MaterialApp, theme, routes
│   └── router/
│       └── app_router.dart            # named routes / go_router (optional)
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   └── injection.dart             # get_it / manual wiring
│   ├── error/
│   │   ├── failures.dart              # Failure hierarchy
│   │   └── exceptions.dart
│   ├── network/
│   │   └── api_client.dart            # when API exists
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/
│       └── either.dart                # optional Result/Either helper
│
└── features/
    └── home/
        ├── domain/
        │   ├── entities/
        │   │   ├── feature_highlight.dart
        │   │   └── home_content.dart
        │   ├── repositories/
        │   │   └── home_repository.dart    # abstract
        │   └── usecases/
        │       ├── get_home_content.dart
        │       └── on_add_money_tapped.dart  # placeholder / analytics hook
        │
        ├── data/
        │   ├── models/
        │   │   └── home_content_model.dart   # JSON ↔ entity mappers
        │   ├── datasources/
        │   │   ├── home_remote_data_source.dart
        │   │   └── home_local_data_source.dart  # optional cache
        │   └── repositories/
        │       └── home_repository_impl.dart
        │
        └── presentation/
            ├── bloc/                       # or cubit/
            │   ├── home_bloc.dart
            │   ├── home_event.dart
            │   └── home_state.dart
            ├── pages/
            │   └── home_page.dart
            └── widgets/
                ├── money_background.dart
                ├── money_hero.dart
                ├── feature_card.dart
                └── gift_card_tile.dart
```

Future features (e.g. `wallet`, `gift_card`, `settings`) follow the same `domain / data / presentation` pattern under `features/`.

---

## Layer responsibilities

### Domain

| Piece | Role |
|-------|------|
| **Entity** | Pure business objects (`FeatureHighlight`, `HomeContent`) — no Flutter, no JSON |
| **Repository (abstract)** | Contract: `Future<Either<Failure, HomeContent>> getHomeContent()` |
| **Use case** | Single action: `GetHomeContent`, `SubmitAddMoney`. Calls one repository method |

Example entity:

```dart
class FeatureHighlight {
  const FeatureHighlight({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconAsset;
}
```

### Data

| Piece | Role |
|-------|------|
| **Model** | DTO with `fromJson` / `toEntity()` |
| **Data source** | Remote API, local JSON asset, or hardcoded mock for assignment |
| **Repository impl** | Maps exceptions → `Failure`, models → entities |

For early development, `HomeLocalDataSource` can return static JSON or a const list — swap to HTTP later without changing domain or UI contracts.

### Presentation

| Piece | Role |
|-------|------|
| **Page** | `HomePage` — listens to state, builds `Scaffold` / `Stack` |
| **Widgets** | Dumb UI; receive data via constructor |
| **Bloc / Cubit** | Maps user events → use cases → emits `HomeState` |

Presentation **never** parses JSON or calls `http` directly.

### Core

Shared across features: theme, colors, failure types, DI registration, logging, base API client.

---

## State management

**Recommendation:** `flutter_bloc` (Cubit for simple home; full Bloc if many events).

| State | Meaning |
|-------|---------|
| `HomeInitial` | Before first load |
| `HomeLoading` | Fetching content (optional; can skip for local mock) |
| `HomeLoaded` | `HomeContent` + animation phase flags |
| `HomeError` | `Failure` message for retry UI |

| Event / method | Action |
|----------------|--------|
| `HomeStarted` | Run `GetHomeContent`, start intro animation |
| `HomeAddMoneyPressed` | Navigate or show dialog (use case / coordinator) |
| `HomeGiftCardPressed` | Navigate to gift flow |
| `HomeAnimationCompleted` | Set flag so stagger logic does not repeat |

Alternative: **Riverpod** with `AsyncNotifier` — same layering; only presentation wiring changes.

---

## Data flow (home feature)

```
User opens app
      │
      ▼
HomePage dispatches HomeStarted
      │
      ▼
HomeBloc ──► GetHomeContent (use case)
      │
      ▼
HomeRepository (interface)
      │
      ▼
HomeRepositoryImpl ──► HomeLocalDataSource / Remote
      │
      ▼
HomeContentModel.toEntity() → HomeContent
      │
      ▼
HomeBloc emits HomeLoaded
      │
      ▼
HomePage builds widgets + drives AnimationController
```

User taps **Add Money**:

```
HomeAddMoneyPressed → OnAddMoneyTapped (use case)
      → repository / analytics / navigation callback
```

---

## Dependency injection

Use **get_it** (or manual `main()` wiring for minimal scope).

Registration order in `core/di/injection.dart`:

1. Core services (`ApiClient`)
2. Data sources
3. Repository implementations (bind to abstract interfaces)
4. Use cases
5. Blocs / Cubits (factory — new instance per route if needed)

```dart
// Illustrative
getIt.registerLazySingleton<HomeRepository>(
  () => HomeRepositoryImpl(local: getIt()),
);
getIt.registerFactory(() => GetHomeContent(getIt()));
getIt.registerFactory(() => HomeBloc(getHomeContent: getIt()));
```

---

## Error handling

```dart
// core/error/failures.dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure { ... }
class CacheFailure extends Failure { ... }
```

Repository catches `Exception`, returns `Left(Failure)` or throws mapped failure. Bloc exposes user-facing message in `HomeError`.

---

## Routing (when app grows)

| Approach | When |
|----------|------|
| Named `Navigator` routes | 2–3 screens (assignment) |
| `go_router` | Deep links, nested nav |

Keep route **names** in `app/router/`; pages stay in `features/*/presentation/pages/`.

---

## Testing strategy

| Layer | What to test |
|-------|----------------|
| Domain | Use cases with mocked repository |
| Data | Repository impl + model parsing (golden JSON fixtures) |
| Presentation | Bloc tests with `bloc_test`; widget tests for `FeatureCard` |
| Integration | Optional: pump `HomePage` with mocked bloc |

```
test/
  features/
    home/
      domain/get_home_content_test.dart
      data/home_repository_impl_test.dart
      presentation/home_bloc_test.dart
```

---

## Implementation phases

| Phase | Deliverable |
|-------|-------------|
| **0** | `core/theme`, `app/flick_app.dart`, strip demo counter from `main.dart` |
| **1** | `home` domain entities + `GetHomeContent` + mock repository |
| **2** | `HomePage` static UI per [UI_HOME_SCREEN_PLAN.md](./UI_HOME_SCREEN_PLAN.md) |
| **3** | `HomeBloc` + wire list of features from use case |
| **4** | Intro animation in presentation only |
| **5** | Remote API + real repository (if assignment requires backend) |
| **6** | Additional features (`gift_card`, `add_money`) as new feature modules |

---

## Conventions

- **Naming:** `snake_case` files; `PascalCase` types; suffixes `Page`, `Bloc`, `Repository`, `Model`, `Entity`.
- **Imports:** package imports only (`package:flick_tv/...`); avoid deep relative `../../../`.
- **Widgets:** Prefer `const` constructors where possible; pass `FeatureHighlight` into `FeatureCard`, not raw strings from bloc in many places.
- **Animation:** Keep `AnimationController` in `HomePage` or a dedicated `HomeIntroAnimator` widget — not in domain or data.

---

## Open decisions (fill in as you build)

| Decision | Options | Notes |
|----------|---------|-------|
| State management | Bloc vs Riverpod | Bloc assumed above |
| API | REST vs mock JSON asset | Start mock/local |
| Navigation | Navigator vs go_router | Navigator OK for v1 |
| DI | get_it vs manual | get_it scales better |

---

## Related docs

- [UI_HOME_SCREEN_PLAN.md](./UI_HOME_SCREEN_PLAN.md) — visual spec, widgets, animation timeline
- [README.md](../README.md) — project setup and links to these docs

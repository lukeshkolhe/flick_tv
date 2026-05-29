import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Loads home content when the screen is first shown.
final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomeAddMoneyPressed extends HomeEvent {
  const HomeAddMoneyPressed();
}

final class HomeGiftCardPressed extends HomeEvent {
  const HomeGiftCardPressed();
}

/// Fired when the intro animation sequence finishes.
final class HomeAnimationCompleted extends HomeEvent {
  const HomeAnimationCompleted();
}

final class HomeRetryPressed extends HomeEvent {
  const HomeRetryPressed();
}

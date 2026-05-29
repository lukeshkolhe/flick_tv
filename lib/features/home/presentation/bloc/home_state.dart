import 'package:equatable/equatable.dart';
import 'package:flick_tv/features/home/domain/entities/home_content.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.content,
    this.introAnimationCompleted = false,
  });

  final HomeContent content;
  final bool introAnimationCompleted;

  HomeLoaded copyWith({
    HomeContent? content,
    bool? introAnimationCompleted,
  }) {
    return HomeLoaded(
      content: content ?? this.content,
      introAnimationCompleted:
          introAnimationCompleted ?? this.introAnimationCompleted,
    );
  }

  @override
  List<Object?> get props => [content, introAnimationCompleted];
}

final class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

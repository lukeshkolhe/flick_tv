import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flick_tv/core/error/exceptions.dart';
import 'package:flick_tv/features/home/domain/repositories/home_repository.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_event.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRetryPressed>(_onStarted);
    on<HomeAddMoneyPressed>(_onAddMoneyPressed);
    on<HomeGiftCardPressed>(_onGiftCardPressed);
    on<HomeAnimationCompleted>(_onAnimationCompleted);
  }

  final HomeRepository _homeRepository;

  Future<void> _onStarted(HomeEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    try {
      final content = await _homeRepository.getHomeContent();
      emit(HomeLoaded(content: content));
    } on FailureException catch (e) {
      emit(HomeError(message: e.failure.message));
    }
  }

  Future<void> _onAddMoneyPressed(
    HomeAddMoneyPressed event,
    Emitter<HomeState> emit,
  ) async {
    await _homeRepository.onAddMoneyTapped();
    // Navigation / side effects will be handled from the UI layer later.
  }

  Future<void> _onGiftCardPressed(
    HomeGiftCardPressed event,
    Emitter<HomeState> emit,
  ) async {
    await _homeRepository.onGiftCardTapped();
  }

  void _onAnimationCompleted(
    HomeAnimationCompleted event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(introAnimationCompleted: true));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flick_tv/core/constants/app_strings.dart';
import 'package:flick_tv/core/di/injection.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/core/widgets/app_loading_indicator.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_bloc.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_event.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_state.dart';
import 'package:flick_tv/features/home/presentation/widgets/home_loaded_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => const SizedBox.shrink(),
            HomeLoading() => const Center(child: AppLoadingIndicator()),
            HomeLoaded() => HomeLoadedView(
                content: state.content,
                skipIntroAnimation: state.introAnimationCompleted,
              ),
            HomeError(:final message) => _HomeErrorBody(message: message),
          };
        },
      ),
    );
  }
}

class _HomeErrorBody extends StatelessWidget {
  const _HomeErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeRetryPressed());
                },
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

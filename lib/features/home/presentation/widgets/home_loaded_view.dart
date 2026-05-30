import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flick_tv/app/router/app_router.dart';
import 'package:flick_tv/core/theme/app_colors.dart';
import 'package:flick_tv/core/widgets/primary_cta_button.dart';
import 'package:flick_tv/features/home/domain/entities/home_content.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_bloc.dart';
import 'package:flick_tv/features/home/presentation/bloc/home_event.dart';
import 'package:flick_tv/features/home/presentation/widgets/confetti_layer.dart';
import 'package:flick_tv/features/home/presentation/widgets/feature_card.dart';
import 'package:flick_tv/features/home/presentation/widgets/claim_gift_card_row.dart';
import 'package:flick_tv/features/home/presentation/widgets/home_top_bar.dart';
import 'package:flick_tv/features/home/presentation/widgets/money_background.dart';
import 'package:flick_tv/features/home/presentation/widgets/money_hero.dart';

class HomeLoadedView extends StatefulWidget {
  const HomeLoadedView({
    required this.content,
    this.skipIntroAnimation = false,
    super.key,
  });

  final HomeContent content;
  final bool skipIntroAnimation;

  @override
  State<HomeLoadedView> createState() => _HomeLoadedViewState();
}

class _HomeLoadedViewState extends State<HomeLoadedView>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 5500);

  /// Approximate height of wallet + brand + MicroDrama block for centering math.
  static const _heroBlockHeight = 236.0;

  late final AnimationController _controller;

  late final Animation<double> _patternOpacity;
  late final Animation<double> _confettiOpacity;
  late final Animation<double> _walletOpacity;
  late final Animation<double> _walletScale;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _heroPosition;
  late final Animation<double> _settingsOpacity;
  late final List<Animation<double>> _cardOpacities;
  late final Animation<double> _ctaOpacity;
  late final Animation<double> _giftOpacity;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);

    _patternOpacity = _tween(0.05, 0.20);
    // Confetti only during wallet reveal; gone before "Flick TV" text.
    _confettiOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 55,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.38, curve: Curves.easeInOut),
      ),
    );
    _walletOpacity = _tween(0.18, 0.38);
    _walletScale = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.38, curve: Curves.easeOutBack),
      ),
    );
    _brandOpacity = _tween(0.38, 0.48);
    _titleOpacity = _tween(0.48, 0.58);
    _titleSlide = Tween<double>(begin: 28, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.48, 0.58, curve: Curves.easeOutCubic),
      ),
    );
    // 0 = vertically centered; 1 = compact slot under top bar (like reference video).
    _heroPosition = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.72, curve: Curves.easeInOutCubic),
      ),
    );
    _settingsOpacity = _tween(0.58, 0.68);
    _cardOpacities = [
      _tween(0.68, 0.78),
      _tween(0.76, 0.86),
      _tween(0.84, 0.94),
    ];
    _ctaOpacity = _tween(0.88, 1.0);
    _giftOpacity = _tween(0.90, 1.0);
    _footerOpacity = _tween(0.92, 1.0);

    if (widget.skipIntroAnimation) {
      _controller.value = 1;
    } else {
      _controller.forward().whenComplete(_onIntroComplete);
    }
  }

  Animation<double> _tween(double start, double end) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  void _onIntroComplete() {
    if (!mounted) return;
    final bloc = context.read<HomeBloc>();
    if (!bloc.isClosed) {
      bloc.add(const HomeAnimationCompleted());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: MoneyBackground(patternOpacity: _patternOpacity.value),
            ),
            if (!widget.skipIntroAnimation)
              Positioned.fill(
                child: ConfettiLayer(
                  opacity: _confettiOpacity.value,
                  walletReveal: _walletOpacity.value,
                  brandReveal: _brandOpacity.value,
                ),
              ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final areaHeight = constraints.maxHeight;
                  const topBarReserve = 56.0;
                  // Intro: hero block centered on screen (like reference video).
                  final centerTop = (areaHeight - _heroBlockHeight) / 2;
                  const finalTop = topBarReserve;
                  final heroTop =
                      centerTop + (finalTop - centerTop) * _heroPosition.value;
                  final listTop = finalTop + _heroBlockHeight + 16;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: listTop,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i < content.features.length;
                                  i++) ...[
                                Opacity(
                                  opacity: i < _cardOpacities.length
                                      ? _cardOpacities[i].value
                                      : 1,
                                  child: FeatureCard(
                                    highlight: content.features[i],
                                  ),
                                ),
                            if (i < content.features.length - 1)
                              const SizedBox(height: 14),
                              ],
                              const SizedBox(height: 20),
                              Opacity(
                                opacity: _ctaOpacity.value,
                                child: PrimaryCtaButton(
                                  label: content.addMoneyLabel,
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                          const HomeAddMoneyPressed(),
                                        );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.addMoney,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Opacity(
                                opacity: _giftOpacity.value,
                            child: ClaimGiftCardRow(
                              title: content.giftCardTitle,
                              subtitle: content.giftCardSubtitle,
                              onTap: () {
                                    context.read<HomeBloc>().add(
                                          const HomeGiftCardPressed(),
                                        );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.giftCard,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              Opacity(
                                opacity: (_footerOpacity.value * 0.55).clamp(0, 1),
                                child: Text(
                                  content.footerWatermark,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.footerWatermark,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: heroTop,
                        left: 20,
                        right: 20,
                        child: MoneyHero(
                          brandName: content.brandName,
                          featureTitle: content.featureTitle,
                          walletOpacity: _walletOpacity.value,
                          walletScale: _walletScale.value,
                          brandOpacity: _brandOpacity.value,
                          titleOpacity: _titleOpacity.value,
                          titleSlide: _titleSlide.value,
                        ),
                      ),
                      HomeTopBar(
                        settingsOpacity: _settingsOpacity.value,
                        onBack: () => Navigator.maybePop(context),
                        onSettings: () {},
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:ecommerce/core/route/route_name.dart';
import 'package:ecommerce/core/storage/token_storage.dart';
import 'package:ecommerce/core/theme/ecommerce_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  static const String _appName = 'Shop';
  static const String _tagline = 'Tout ce que tu aimes, livré chez toi';
  static const Duration _splashDuration = Duration(seconds: 2);

  late final AnimationController _ctrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: _splashDuration,
    )..forward();

    _logoScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _textFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.75, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.4, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _loaderFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    );

    _goNext();
  }

  Future<bool> _hasSession() async {
    try {
      final token = await ref
          .read(tokenStorageProvider)
          .readAccess()
          .timeout(_splashDuration, onTimeout: () => null);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _goNext() async {
    final results = await Future.wait<Object?>([
      _hasSession(),
      Future<void>.delayed(_splashDuration),
    ]);
    if (!mounted) return;
    final isAuthenticated = results.first as bool;
    context.go(isAuthenticated ? HomeRoute : LoginRoute);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, AppTheme.primaryLight],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -70, right: -60, child: _circle(240, 0.10)),
            Positioned(bottom: -90, left: -70, child: _circle(280, 0.08)),
            Positioned(top: 180, left: -40, child: _circle(110, 0.07)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 30,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          size: 54,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          const Text(
                            _appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              _tagline,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: FadeTransition(
                    opacity: _loaderFade,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  Timer? _progressTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _progressTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _progressController.forward();
    });
    _navTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) Get.offNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _navTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryFixed, AppColors.surfaceContainerHigh],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.primaryFixedDim.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      64,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                                    child: Container(),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: Image.asset(
                                    AppAssets.logo,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.bolt, size: 100, color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'ImpactForge',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'AUTHENTIC',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.outline,
                                        letterSpacing: 2,
                                      ),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: const BoxDecoration(color: AppColors.outline, shape: BoxShape.circle),
                                ),
                                Text(
                                  'ACTION',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.outline,
                                        letterSpacing: 2,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '"Bridging Passion with Purpose"',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 200,
                            height: 6,
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, _) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: Stack(
                                    children: [
                                      Container(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                                      FractionallySizedBox(
                                        widthFactor: _progressController.value,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [AppColors.primary, AppColors.secondary],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '80G | 12A & Community Registered',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.outline,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'www.impactforge.in',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

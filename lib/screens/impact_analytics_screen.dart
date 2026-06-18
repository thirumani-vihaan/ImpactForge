import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class ImpactAnalyticsScreen extends StatelessWidget {
  const ImpactAnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) => const ImpactAnalyticsScreenContent();
}

class ImpactAnalyticsScreenContent extends StatefulWidget {
  const ImpactAnalyticsScreenContent({super.key});
  @override
  State<ImpactAnalyticsScreenContent> createState() => _ImpactAnalyticsScreenContentState();
}

class _ImpactAnalyticsScreenContentState extends State<ImpactAnalyticsScreenContent> {
  String _period = '6 Months';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.to.currentUser;
      final karmaPoints = user?.karmaPoints ?? 0;
      final hours = user?.timeDonatedHours ?? 0;
      final lives = user?.livesTouched ?? 0;
      final avatarUrl = user?.avatarUrl.isNotEmpty == true ? user!.avatarUrl : AppAssets.impactAvatar;

      // Calculate progress to next milestone level (milestone every 500 points)
      final pointsInCurrentLevel = karmaPoints % 500;
      final progress = pointsInCurrentLevel / 500.0;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppTopBar(avatarUrl: avatarUrl),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 100),
          child: Column(
            children: [
              GlassCard(
                child: Column(
                  children: [
                    SizedBox(
                      width: 130, // Increased size to prevent overlays
                      height: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress == 0.0 && karmaPoints > 0 ? 1.0 : progress, 
                            strokeWidth: 10, 
                            backgroundColor: AppColors.surfaceVariant, 
                            valueColor: const AlwaysStoppedAnimation(AppColors.primary)
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min, 
                            children: [
                              Text(
                                '$karmaPoints', 
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: karmaPoints > 9999 ? 22 : 28, // Scaled down dynamically to prevent overlays
                                  fontWeight: FontWeight.w800
                                )
                              ),
                              Text(
                                'Points', 
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Karma Points Milestone', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'You are level ${user?.level ?? 1}. Earn ${(500 - pointsInCurrentLevel)} more points to level up!', 
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), 
                      textAlign: TextAlign.center
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _metricCard(context, '$hours Hrs', 'Volunteering Hours', 'Total time donated', Icons.schedule)),
                  const SizedBox(width: 12),
                  Expanded(child: _metricCard(context, '$lives', 'Lives Touched', 'Direct Community Impact', Icons.people)),
                ],
              ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Points Velocity', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((e) {
                        final heights = [0.4, 0.55, 0.5, 0.9, 0.65, 0.45, 0.35];
                        final highlight = e.key == 3;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    heightFactor: heights[e.key],
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: highlight ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(e.value, style: Theme.of(context).textTheme.labelSmall),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tasks Completion Journey', style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: ['6 Months', '1 Year'].map((p) {
                          final selected = _period == p;
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: FilterChip(
                              label: Text(p, style: TextStyle(fontSize: 11)),
                              selected: selected,
                              onSelected: (_) => setState(() => _period = p),
                              selectedColor: AppColors.primaryContainer,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: CustomPaint(
                      painter: _LineChartPainter(),
                      size: const Size(double.infinity, 100),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'].map((m) => Text(m, style: Theme.of(context).textTheme.labelSmall)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryGradientButton(
              label: 'Start New Contribution Task',
              onPressed: () => Get.toNamed(AppRoutes.home, arguments: AppNavTab.tasks),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.leaderboard),
              child: const Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
    });
  }

  Widget _metricCard(BuildContext context, String value, String label, String sub, IconData icon) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
          Text(sub, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary.withValues(alpha: 0.3), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final points = [0.2, 0.35, 0.3, 0.55, 0.5, 0.75].map((y) => Offset(0, 0)).toList();
    for (var i = 0; i < 6; i++) {
      points[i] = Offset(size.width * i / 5, size.height * (1 - [0.2, 0.35, 0.3, 0.55, 0.5, 0.75][i]));
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_shell.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => const AppShell();
}

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.to.currentUser;
      final userName = user?.name ?? 'Volunteer';
      final activeTasksList = TaskController.to.activeTasks;
      final karmaPoints = user?.karmaPoints ?? 0;
      final livesTouched = user?.livesTouched ?? 0;
      final avatarUrl = user?.avatarUrl.isNotEmpty == true 
          ? user!.avatarUrl 
          : AppAssets.profileAppBarAvatar;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppTopBar(avatarUrl: avatarUrl),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Namaste, $userName!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                "Ready to make a difference today? Here's your impact snapshot.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              
              // Robust layout to prevent overlaps on small devices
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context, 
                      icon: Icons.assignment_outlined, 
                      iconColor: AppColors.primary, 
                      badge: 'Active', 
                      value: '${activeTasksList.length}', 
                      label: 'Active Tasks'
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      context,
                      icon: Icons.star_outline,
                      iconColor: AppColors.secondary,
                      badge: 'Level ${user?.level ?? 1}',
                      value: '$karmaPoints',
                      label: 'Karma Points',
                      borderColor: AppColors.secondary,
                      gradient: LinearGradient(colors: [Colors.white, AppColors.secondaryContainer.withValues(alpha: 0.05)]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _livesTouchedCard(context, livesTouched),
              
              const SizedBox(height: 24),
              _heroBanner(context),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active Tasks', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                  TextButton.icon(
                    onPressed: () => navigateToShell(AppNavTab.tasks),
                    icon: const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                    label: Text('View All', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (activeTasksList.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text('No active tasks currently. Check back later!', style: TextStyle(color: AppColors.onSurfaceVariant)),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeTasksList.take(3).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = activeTasksList[index];
                    
                    // Match to general list to get category and details
                    final mainTask = TaskController.to.tasks.firstWhere(
                      (t) => t.id == task.id || t.title.toLowerCase() == task.title.toLowerCase(),
                      orElse: () => TaskModel(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        category: 'Community',
                        deadlineText: task.dueText,
                        location: '',
                        volunteersCount: 0,
                        points: 150,
                        peopleEmpowered: 0,
                        extendedDescription: task.description,
                        instructions: [],
                        resources: [],
                      ),
                    );

                    IconData icon;
                    Color iconColor;
                    switch (mainTask.category) {
                      case 'Education':
                        icon = Icons.description;
                        iconColor = AppColors.primary;
                        break;
                      case 'Environment':
                        icon = Icons.eco;
                        iconColor = AppColors.secondary;
                        break;
                      case 'Healthcare':
                        icon = Icons.healing;
                        iconColor = AppColors.tertiary;
                        break;
                      default:
                        icon = Icons.groups;
                        iconColor = AppColors.primary;
                    }

                    return _activeTaskCard(
                      context,
                      icon: icon,
                      iconColor: iconColor,
                      title: task.title,
                      subtitle: task.description,
                      chip: task.dueText,
                      chipColor: task.dueText.toLowerCase().contains('h') ? AppColors.errorContainer : AppColors.surfaceVariant,
                      chipTextColor: task.dueText.toLowerCase().contains('h') ? AppColors.onErrorContainer : AppColors.onSurfaceVariant,
                      onTap: () => Get.toNamed(AppRoutes.taskDetails, arguments: mainTask),
                    );
                  },
                ),
              const SizedBox(height: 24),
              GlassCard(
                padding: const EdgeInsets.all(32),
                borderRadius: 16,
                border: Border.all(color: AppColors.outlineVariant, width: 2),
                gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.05), AppColors.secondary.withValues(alpha: 0.05)]),
                child: Column(
                  children: [
                    Icon(Icons.format_quote, size: 40, color: AppColors.primary.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text('"The best way to find yourself is to lose yourself in the service of others."', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text('— Mahatma Gandhi', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _statCard(BuildContext context, {required IconData icon, required Color iconColor, required String badge, required String value, required String label, Color? borderColor, Gradient? gradient}) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      gradient: gradient,
      border: borderColor != null ? Border(left: BorderSide(color: borderColor, width: 4)) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 18)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)), child: Text(badge, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: iconColor, fontSize: 10))),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 0.5), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _livesTouchedCard(BuildContext context, int count) {
    double progress = count / 100.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(colors: [Colors.white, AppColors.primaryContainer.withValues(alpha: 0.05)]),
      border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primaryFixed.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_graph, color: AppColors.primary, size: 18)),
            Text('GOAL: 100 LIVES', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$count', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
              Text('LIVES TOUCHED', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary))),
        ],
      ),
    );
  }

  Widget _heroBanner(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 192,
        child: Stack(fit: StackFit.expand, children: [
          CachedNetworkImage(imageUrl: AppAssets.winterBlanketHero, fit: BoxFit.cover),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.8)]))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Winter Blanket Drive 2026', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 4),
              Text('Join our mission to provide warmth to 500 families in rural UP this winter.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              const SizedBox(height: 12),
              Row(children: [
                ElevatedButton(onPressed: () => navigateToShell(AppNavTab.tasks), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))), child: const Text('Join Mission')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () => navigateToShell(AppNavTab.tasks), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.3)), backgroundColor: Colors.white.withValues(alpha: 0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))), child: const Text('Details')),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _activeTaskCard(BuildContext context, {required IconData icon, required Color iconColor, required String title, required String subtitle, required String chip, required Color chipColor, required Color chipTextColor, VoidCallback? onTap}) {
    return GlassCard(
      onTap: onTap,
      child: Row(children: [
        Container(width: 64, height: 60, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
        ])),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(999)), child: Text(chip, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: chipTextColor, fontSize: 9))),
          IconButton(icon: const Icon(Icons.chevron_right, size: 18), onPressed: onTap, constraints: const BoxConstraints(), padding: const EdgeInsets.only(top: 4)),
        ]),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const ProfileScreenContent();
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.to.currentUser;
      if (user == null) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final avatarUrl = user.avatarUrl.isNotEmpty ? user.avatarUrl : AppAssets.profileAppBarAvatar;
      final livesTouched = user.livesTouched;
      final karmaPoints = user.karmaPoints;
      final level = user.level;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppTopBar(showBack: false, avatarUrl: avatarUrl),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        AppAvatar(url: avatarUrl, size: 100, borderWidth: 4, name: user.name),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                            child: const Icon(Icons.verified, size: 16, color: AppColors.onPrimaryFixed),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    Text('${user.role.capitalizeFirst} • Active Member', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star, color: AppColors.tertiaryFixedDim, size: 18),
                        const SizedBox(width: 8),
                        Text('$karmaPoints Karma Points', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                      ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: _statCard(context, '$level', 'Profile Level', 'Level Up at ${(level * 500)} pts', Icons.military_tech, AppColors.secondaryContainer)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard(context, '$livesTouched', 'Lives Touched', 'Direct Community Impact', Icons.favorite_border, AppColors.tertiaryContainer)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Badges', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _badge('🌱', 'Nature Hero'),
                          _badge('🎓', 'Educator'),
                          _badge('❤️', 'Top Donor'),
                          _badge('👥', 'Team Lead'),
                          _badge('🔒', 'Veteran', locked: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _actionTile(context, Icons.edit, 'Edit Profile', () => Get.toNamed(AppRoutes.editProfile)),
              _actionTile(context, Icons.settings, 'Account Settings', () => Get.toNamed(AppRoutes.settings)),
              _actionTile(context, Icons.logout, 'Logout', () => AuthController.to.logout(), isError: true),
            ],
          ),
        ),
      );
    });
  }

  Widget _statCard(BuildContext context, String value, String label, String sub, IconData icon, Color color) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color)),
        const SizedBox(height: 12),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(color: AppColors.primary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _badge(String emoji, String label, {bool locked = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Opacity(
        opacity: locked ? 0.5 : 1,
        child: Column(children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.8), AppColors.secondary.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ]),
      ),
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool isError = false}) {
    return ListTile(
      leading: Icon(icon, color: isError ? AppColors.error : AppColors.primary),
      title: Text(label, style: TextStyle(color: isError ? AppColors.error : AppColors.onSurface)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

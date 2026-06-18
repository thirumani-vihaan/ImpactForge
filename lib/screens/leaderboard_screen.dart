import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/leaderboard_controller.dart';
import '../controllers/auth_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;
    final leaderboardController = LeaderboardController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(avatarUrl: authController.currentUser?.avatarUrl.isNotEmpty == true ? authController.currentUser!.avatarUrl : AppAssets.profileAppBarAvatar),
      body: RefreshIndicator(
        onRefresh: () => leaderboardController.fetchLeaderboard(),
        child: Obx(() {
          if (leaderboardController.isLoading.value && leaderboardController.leaderboardUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final podium = leaderboardController.podiumUsers;
          final others = leaderboardController.otherUsers;
          final currentUser = authController.currentUser;
          
          final myRank = currentUser != null ? leaderboardController.getUserRank(currentUser.name) : -1;
          final myPoints = currentUser?.karmaPoints ?? 0;
          final myName = currentUser?.name ?? 'You';
          final myAvatar = currentUser?.avatarUrl.isNotEmpty == true ? currentUser!.avatarUrl : AppAssets.profileAppBarAvatar;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                  child: Text('Monthly Impact', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(height: 8),
                Text('Top Contributors', style: Theme.of(context).textTheme.headlineMedium),
                Text('Recognizing our most active change-makers this month.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                
                // Podium Section
                if (podium.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2nd Place
                      if (podium.length > 1)
                        _podium(context, podium[1].avatarUrl, podium[1].name, '${podium[1].points}', 160, '2')
                      else
                        const Spacer(),
                      
                      // 1st Place
                      _podium(context, podium[0].avatarUrl, podium[0].name, '${podium[0].points}', 200, '1', trophy: true),
                      
                      // 3rd Place
                      if (podium.length > 2)
                        _podium(context, podium[2].avatarUrl, podium[2].name, '${podium[2].points}', 140, '3')
                      else
                        const Spacer(),
                    ],
                  ),
                
                const SizedBox(height: 24),

                // Other ranks list
                ...others.asMap().entries.map((entry) {
                  final user = entry.value;
                  return _listItem(
                    context, 
                    user.rank, 
                    user.avatarUrl, 
                    user.name, 
                    user.badgeText, 
                    '${user.tasksCompleted} Tasks', 
                    '${user.points} POINTS'
                  );
                }),

                const SizedBox(height: 16),
                
                // Sticky user indicator
                if (currentUser != null && myRank != -1) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  _listItem(
                    context,
                    myRank,
                    myAvatar,
                    '$myName (You)',
                    'Volunteer',
                    'Level ${currentUser.level}',
                    '$myPoints POINTS',
                    highlight: true,
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _podium(BuildContext context, String avatar, String name, String pts, double height, String rank, {bool trophy = false}) {
    final safeAvatar = avatar.isNotEmpty ? avatar : AppAssets.profileAppBarAvatar;
    return Expanded(
      child: Column(
        children: [
          if (trophy) const Icon(Icons.emoji_events, color: AppColors.tertiaryFixedDim, size: 28),
          AppAvatar(url: safeAvatar, size: 64, borderWidth: 3, name: name),
          const SizedBox(height: 8),
          Container(
            height: height,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryContainer, AppColors.primary]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rank, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                Text(pts, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _listItem(BuildContext context, int rank, String avatar, String name, String badge, String subtitle, String points, {bool highlight = false}) {
    final safeAvatar = avatar.isNotEmpty ? avatar : AppAssets.profileAppBarAvatar;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryContainer.withValues(alpha: 0.15) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: highlight ? AppColors.primary : AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Text('$rank', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 12),
          AppAvatar(
            url: safeAvatar,
            size: 44,
            borderWidth: 0,
            name: name,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 2),
                
                // Wrap widget to prevent text overlap/overflow
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.secondaryFixed.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(999)),
                      child: Text(badge, style: Theme.of(context).textTheme.labelSmall),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          Text(points, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

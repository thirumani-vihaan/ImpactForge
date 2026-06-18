import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/leaderboard_controller.dart';
import '../models/submission_model.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _showCreateTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: 'Education');
    final deadCtrl = TextEditingController(text: 'Ends in 3 days');
    final pointsCtrl = TextEditingController(text: '200');
    final locCtrl = TextEditingController(text: 'Lucknow');

    Get.dialog(
      AlertDialog(
        title: const Text('Create New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Task Title')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: 'Education',
                items: ['Education', 'Environment', 'Healthcare', 'Community']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => catCtrl.text = val ?? 'Education',
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              TextField(controller: deadCtrl, decoration: const InputDecoration(labelText: 'Deadline Description')),
              const SizedBox(height: 8),
              TextField(controller: pointsCtrl, decoration: const InputDecoration(labelText: 'Karma Points (Reward)'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) {
                Get.snackbar('Error', 'Task Title is required.');
                return;
              }
              TaskController.to.createNewTask(
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                category: catCtrl.text,
                deadline: deadCtrl.text.trim(),
                points: int.tryParse(pointsCtrl.text) ?? 150,
                location: locCtrl.text.trim(),
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showBroadcastDialog(BuildContext context) {
    final msgCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Send Broadcast Announcement'),
        content: TextField(
          controller: msgCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter announcement text to display to all volunteers...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (msgCtrl.text.trim().isEmpty) {
                Get.snackbar('Error', 'Announcement cannot be empty.');
                return;
              }
              Get.back();
              Get.snackbar(
                'Broadcast Sent',
                'Successfully broadcasted to all volunteers!',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Broadcast'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    final emailCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Invite Volunteers'),
        content: TextField(
          controller: emailCtrl,
          decoration: const InputDecoration(
            hintText: 'volunteer@example.com',
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (emailCtrl.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please enter an email.');
                return;
              }
              Get.back();
              Get.snackbar(
                'Invite Dispatched',
                'Invitation sent successfully to ${emailCtrl.text.trim()}!',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;
    final taskController = TaskController.to;
    final leaderboardController = LeaderboardController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        showBack: true, 
        onBack: () => authController.logout(), // Back out of admin session triggers logout/clean state
        avatarUrl: authController.currentUser?.avatarUrl ?? AppAssets.adminAvatar
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTaskDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create New Task', style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () => taskController.fetchTasksAndSubmissions(),
        child: Obx(() {
          final totalVolunteers = leaderboardController.leaderboardUsers.length;
          final activeTasksCount = taskController.activeTasks.length;
          final pendingSubmissions = taskController.submissions.toList();
          final totalSubmissions = taskController.submissions.length;
  
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard Overview', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text("Welcome back, Admin. Here's what's happening today.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _statCard(context, '$totalVolunteers', 'Total Volunteers', 'Registered Users', AppColors.primary, Icons.group)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard(context, '$activeTasksCount', 'Active Tasks', 'Open Opportunities', AppColors.secondaryContainer, Icons.assignment)),
                  ],
                ),
                const SizedBox(height: 12),
                _statCard(context, '${pendingSubmissions.length}', 'Pending Submissions', 'Awaiting Action', AppColors.error, Icons.pending_actions, fullWidth: true),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Submissions', style: Theme.of(context).textTheme.titleLarge),
                    TextButton(onPressed: () {}, child: Text('Total: $totalSubmissions')),
                  ],
                ),
                if (pendingSubmissions.isEmpty)
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text('All caught up! No pending submissions.', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    ),
                  )
                else
                  ...pendingSubmissions.map((s) => _submissionRow(context, s)),
  
                const SizedBox(height: 24),
                Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _action(context, Icons.campaign, 'Broadcast', () => _showBroadcastDialog(context)),
                    _action(context, Icons.person_add, 'Send Invites', () => _showInviteDialog(context)),
                    _action(context, Icons.analytics, 'Reports', () => Get.toNamed(AppRoutes.impactAnalytics)),
                    _action(context, Icons.leaderboard, 'Leaderboard', () => Get.toNamed(AppRoutes.leaderboard)),
                  ],
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Impact Milestone', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('You are making great progress towards the community target!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${totalSubmissions * 12} Lives Touched', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                          const Text('5,000 Target', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (totalSubmissions * 12 / 5000.0).clamp(0.0, 1.0), 
                        minHeight: 8, 
                        backgroundColor: AppColors.surfaceVariant, 
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, String sub, Color accent, IconData icon, {bool fullWidth = false}) {
    return GlassCard(
      border: Border(top: BorderSide(color: accent, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accent),
              if (fullWidth) Text(sub, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: accent)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          if (!fullWidth) Text(sub, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: accent)),
        ],
      ),
    );
  }

  Widget _submissionRow(BuildContext context, SubmissionModel sub) {
    final avatar = sub.avatarUrl.isNotEmpty ? sub.avatarUrl : AppAssets.adminAvatar;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(
                  url: avatar,
                  size: 40,
                  borderWidth: 0,
                  name: sub.volunteerName,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sub.volunteerName, style: Theme.of(context).textTheme.labelMedium),
                      Text(sub.taskTitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 28), 
                  onPressed: () => TaskController.to.reviewSubmission(sub.id, 'approved'),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 28), 
                  onPressed: () => TaskController.to.reviewSubmission(sub.id, 'rejected'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Proof/Description: "${sub.description}"', 
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(BuildContext context, IconData icon, String label, [VoidCallback? onTap]) {
    return GlassCard(
      onTap: onTap ?? () => Get.snackbar(label, '$label clicked'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

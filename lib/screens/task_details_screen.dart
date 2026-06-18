import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../models/task_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../routes/app_routes.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve task from arguments or fall back to mock default
    final TaskModel task = Get.arguments is TaskModel
        ? Get.arguments as TaskModel
        : TaskModel(
            id: 'task-1',
            title: 'Teach Foundational Mathematics',
            description: 'Join our mission to empower the next generation. This task involves conducting a two-hour virtual or in-person workshop focused on basic arithmetic and problem-solving for children aged 8-12.',
            category: 'Education',
            deadlineText: 'Ends in 2 days',
            points: 250,
            location: ' Lucknow, India',
            volunteersCount: 14,
            peopleEmpowered: 15,
            extendedDescription: 'Conduct virtual mathematical workshop.',
            instructions: ['Review PDF curriculum', 'Schedule session', 'Deliver lesson', 'Submit photos'],
            resources: [],
          );

    final user = AuthController.to.currentUser;
    final avatarUrl = user?.avatarUrl.isNotEmpty == true 
        ? user!.avatarUrl 
        : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=256&h=256&q=80';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.surface.withValues(alpha: 0.9),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Get.back()),
              ),
            ),
            actions: [
              const Padding(padding: EdgeInsets.all(8), child: AppLogo(width: 36, height: 36)),
              Padding(padding: const EdgeInsets.only(right: 12), child: AppAvatar(url: avatarUrl, size: 36)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: AppAssets.taskDetailsHero, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 24,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(999)),
                          child: Text(task.category, style: const TextStyle(color: AppColors.onPrimaryContainer, fontSize: 12)),
                        ),
                        const SizedBox(height: 8),
                        Text(task.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 22)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _infoWidget(context, Icons.timer, task.deadline, 'Deadline'),
                        const SizedBox(width: 12),
                        _infoWidget(context, Icons.location_on_outlined, task.location.trim().isEmpty ? 'Online' : task.location.trim(), 'Location'),
                        const SizedBox(width: 12),
                        _infoWidget(context, Icons.star, '${task.points} Points', 'Reward'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Task Description', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (task.instructions.isEmpty)
                      const Text('No special instructions provided.')
                    else
                      ...task.instructions.asMap().entries.map((entry) => 
                        _instruction(context, entry.key + 1, entry.value.toString())
                      ),
                    const SizedBox(height: 24),
                    Text('Resources', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (task.resources.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('No resources available for this task.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
                      )
                    else
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: task.resources.map((res) {
                            final map = res as Map<String, dynamic>;
                            final name = map['name'] as String? ?? 'Resource';
                            final size = map['size'] as String? ?? 'External';
                            return _resourceCard(context, Icons.insert_drive_file, name, size);
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final isActive = TaskController.to.activeTasks.any((t) => t.id == task.id || t.title.toLowerCase() == task.title.toLowerCase());
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryGradientButton(
              label: isActive ? 'Submit for Approval' : 'Accept & Start Task',
              onPressed: () {
                if (isActive) {
                  Get.toNamed(AppRoutes.taskSubmission, arguments: task);
                } else {
                  TaskController.to.acceptTask(task);
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _infoWidget(BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _instruction(BuildContext context, int n, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 14, backgroundColor: AppColors.primaryContainer, child: Text('$n', style: const TextStyle(color: AppColors.onPrimaryContainer, fontSize: 12))),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }

  Widget _resourceCard(BuildContext context, IconData icon, String title, String sub) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: AppColors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
        child: InkWell(
          onTap: () {
            Get.snackbar(
              'Downloading Resource',
              'Starting download of $title ($sub)...',
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
              icon: const Icon(Icons.download_for_offline, color: Colors.white),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary),
                const Spacer(),
                Text(title, style: Theme.of(context).textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(sub, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/task_model.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) => const TasksScreenContent();
}

class TasksScreenContent extends StatefulWidget {
  const TasksScreenContent({super.key});

  @override
  State<TasksScreenContent> createState() => _TasksScreenContentState();
}

class _TasksScreenContentState extends State<TasksScreenContent> {
  final _filters = ['All Tasks', 'Education', 'Environment', 'Healthcare', 'Community'];

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;
    return Obx(() {
      final user = authController.currentUser;
      final avatarUrl = user?.avatarUrl ?? AppAssets.tasksAvatar;
      final activeFilter = TaskController.to.selectedCategory.value;
      final displayTasks = TaskController.to.filteredTasks;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppTopBar(avatarUrl: avatarUrl),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Volunteer Tasks', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                "Discover opportunities to make a difference. Every task you complete contributes to our community's collective impact.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final selected = activeFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (_) {
                          TaskController.to.selectedCategory.value = f;
                        },
                        backgroundColor: AppColors.surfaceContainerHigh,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (displayTasks.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text('No tasks available for this category.', style: TextStyle(color: AppColors.onSurfaceVariant)),
                  ),
                )
              else
                ...displayTasks.map((t) => _taskCard(t, context)),
            ],
          ),
        ),
      );
    });
  }

  Widget _taskCard(TaskModel task, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        onTap: () => Get.toNamed(AppRoutes.taskDetails, arguments: task),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryChip(task.category),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: task.deadline == 'Urgent' ? AppColors.error : AppColors.outline),
                    const SizedBox(width: 4),
                    Text(task.deadline, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: task.deadline == 'Urgent' ? AppColors.error : AppColors.outline)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(task.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(task.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (task.hasAvatars)
                  Row(
                    children: [
                      for (var i = 0; i < 2; i++)
                        Transform.translate(
                          offset: Offset(-8.0 * i, 0),
                          child: CircleAvatar(radius: 16, backgroundColor: AppColors.secondaryContainer, child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 10))),
                        ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.surfaceContainerHighest,
                          child: Text('+12', style: Theme.of(context).textTheme.labelSmall),
                        ),
                      ),
                    ],
                  )
                else if (task.location.isNotEmpty)
                  Row(children: [const Icon(Icons.location_on, size: 18, color: AppColors.primary), Text(task.location, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary))])
                else
                  Row(children: [const Icon(Icons.verified, size: 18, color: AppColors.primary), Text(' Verified Only', style: Theme.of(context).textTheme.labelSmall)]),
                _acceptButton(task),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String category) {
    Color bg;
    Color fg;
    switch (category) {
      case 'Education':
        bg = AppColors.tertiaryFixed;
        fg = AppColors.onTertiaryFixedVariant;
        break;
      case 'Environment':
        bg = AppColors.secondaryContainer;
        fg = Colors.white;
        break;
      case 'Healthcare':
        bg = AppColors.secondaryContainer;
        fg = Colors.white;
        break;
      default:
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(category, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg)),
    );
  }

  Widget _acceptButton(TaskModel task) {
    return Obx(() {
      final isActive = TaskController.to.activeTasks.any((t) => t.id == task.id || t.title.toLowerCase() == task.title.toLowerCase());
      if (isActive) {
        return OutlinedButton(
          onPressed: () => Get.toNamed(AppRoutes.taskSubmission, arguments: task),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w600)),
        );
      }
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => TaskController.to.acceptTask(task),
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      );
    });
  }
}

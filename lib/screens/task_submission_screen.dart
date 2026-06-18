import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../models/task_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';

class TaskSubmissionScreen extends StatelessWidget {
  const TaskSubmissionScreen({super.key});

  @override
  Widget build(BuildContext context) => const TaskSubmissionScreenContent();
}

class TaskSubmissionScreenContent extends StatefulWidget {
  const TaskSubmissionScreenContent({super.key});
  @override
  State<TaskSubmissionScreenContent> createState() => _TaskSubmissionScreenContentState();
}

class _TaskSubmissionScreenContentState extends State<TaskSubmissionScreenContent> {
  final _summaryController = TextEditingController();
  final _selectedSkills = {'Leadership', 'Community', 'Teaching'};
  String _evidenceUrl = AppAssets.submissionGallery;

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskModel? taskArg;
    if (Get.arguments is TaskModel) {
      taskArg = Get.arguments as TaskModel;
    }

    final TaskModel task = taskArg ??
        (TaskController.to.tasks.isNotEmpty
            ? TaskController.to.tasks.first
            : TaskModel(
                id: 'task-1',
                title: 'Virtual English Mentorship',
                description: 'Support high school students.',
                category: 'Education',
                deadlineText: 'Ends in 2 days',
                location: 'Remote',
                volunteersCount: 0,
                points: 200,
                peopleEmpowered: 0,
                extendedDescription: '',
                instructions: [],
                resources: [],
              ));

    final user = AuthController.to.currentUser;
    final avatarUrl = user?.avatarUrl ?? AppAssets.submissionAvatar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(showBack: true, avatarUrl: avatarUrl),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 700;
                final status = _statusCard(context, task);
                final form = _formCard(context, task);
                if (wide) {
                  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: status),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: form),
                  ]);
                }
                return Column(children: [status, const SizedBox(height: 16), form]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(BuildContext context, TaskModel task) {
    final user = AuthController.to.currentUser;
    final level = user?.level ?? 1;
    final points = user?.karmaPoints ?? 0;
    
    // Calculate progress towards next milestone (next level)
    final pointsInCurrentLevel = points % 500;
    final progress = pointsInCurrentLevel / 500.0;

    return Column(
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SUBMISSION STATUS', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text('Awaiting Upload', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              _row(context, 'Task ID', '#${task.id}'),
              _row(context, 'Profile Level', 'Lvl $level'),
              const SizedBox(height: 12),
              Text('${(progress * 100).toInt()}% to next milestone', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress, backgroundColor: AppColors.surfaceVariant, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Guidelines', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _guideline('Clear photo of the activity'),
              _guideline('Geotagged proof (if applicable)'),
              _guideline('Impact summary (min 50 words)'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _formCard(BuildContext context, TaskModel task) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Volunteer Report', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text('Document your impact and share your journey with the community.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          Text('Evidence Gallery', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _mediaSlot(
                dashed: true, 
                label: 'Add Media', 
                onTap: () => _uploadEvidenceDialog(),
              ),
              const SizedBox(width: 8),
              _mediaSlot(imageUrl: _evidenceUrl),
              const SizedBox(width: 8),
              _mediaSlot(dashed: true, onTap: () => _uploadEvidenceDialog()),
            ],
          ),
          const SizedBox(height: 16),
          Text('Detailed Summary', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _summaryController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe the activity, the people you helped, and the immediate impact observed...',
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outlineVariant)),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._selectedSkills.map((s) => Chip(label: Text(s), backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2))),
              ActionChip(
                label: const Text('+ add'), 
                onPressed: () {
                  final textCtrl = TextEditingController();
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Add Skill Badge'),
                      content: TextField(
                        controller: textCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Teaching, Leadership, Forestry',
                          labelText: 'Skill Name',
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            final skill = textCtrl.text.trim();
                            if (skill.isNotEmpty) {
                              setState(() {
                                _selectedSkills.add(skill);
                              });
                            }
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => PrimaryGradientButton(
            label: 'Submit for Approval',
            isLoading: TaskController.to.isLoading.value,
            onPressed: () async {
              await TaskController.to.submitVolunteerReport(
                taskId: task.id,
                taskTitle: task.title,
                description: _summaryController.text,
              );
              if (!TaskController.to.isLoading.value) {
                Get.back();
              }
            },
          )),
          const SizedBox(height: 8),
          Text('Submitted reports are typically reviewed within 24-48 hours.', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(k, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        Text(v, style: Theme.of(context).textTheme.labelMedium),
      ]),
    );
  }

  Widget _guideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        const Icon(Icons.check_circle_outline, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
  }

  void _uploadEvidenceDialog() {
    final urlCtrl = TextEditingController(text: _evidenceUrl);
    Get.dialog(
      AlertDialog(
        title: const Text('Add Evidence Image'),
        content: TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(
            hintText: 'Enter photo URL...',
            labelText: 'Image URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = urlCtrl.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  _evidenceUrl = val;
                });
              }
              Get.back();
              Get.snackbar(
                'Evidence Added',
                'Successfully added evidence photo!',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Add Photo'),
          ),
        ],
      ),
    );
  }

  Widget _mediaSlot({bool dashed = false, String? imageUrl, String? label, VoidCallback? onTap}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: dashed ? AppColors.outlineVariant : Colors.transparent, width: dashed ? 2 : 0),
              color: dashed ? AppColors.surfaceContainerLow : null,
            ),
            child: dashed
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.add_photo_alternate_outlined, color: AppColors.outline),
                    if (label != null) Text(label, style: Theme.of(context).textTheme.labelSmall),
                  ])
                : ClipRRect(borderRadius: BorderRadius.circular(8), child: CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}

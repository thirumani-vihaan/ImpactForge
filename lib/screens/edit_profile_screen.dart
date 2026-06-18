import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _bioController = TextEditingController();
  final _skills = {'Community Outreach', 'Teaching', 'Event Planning', 'Social Media'};
  final _popular = ['Mentorship', 'Fundraising', 'Graphic Design', 'First Aid'];
  String _selectedAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    final user = AuthController.to.currentUser;
    _nameController = TextEditingController(text: user?.name ?? 'Aarav Sharma');
    _emailController = TextEditingController(text: user?.email ?? 'aarav.v@example.com');
    _bioController.text = user?.bio ?? 'Passionate about community service and educational outreach.';
    _selectedAvatarUrl = user?.avatarUrl.isNotEmpty == true 
        ? user!.avatarUrl 
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.name ?? 'Aarav Sharma')}&background=00685F&color=fff&size=256';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _changeAvatarDialog() {
    final avatars = [
      ('Arjun', 'https://ui-avatars.com/api/?name=Arjun&background=00685F&color=fff&size=256'),
      ('Priya', 'https://ui-avatars.com/api/?name=Priya&background=825100&color=fff&size=256'),
      ('Rohan', 'https://ui-avatars.com/api/?name=Rohan&background=316BF3&color=fff&size=256'),
      ('Anjali', 'https://ui-avatars.com/api/?name=Anjali&background=BA1A1A&color=fff&size=256'),
    ];

    Get.dialog(
      AlertDialog(
        title: const Text('Select Avatar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose an Indian profile avatar:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: avatars.map((av) => GestureDetector(
                onTap: () {
                  setState(() => _selectedAvatarUrl = av.$2);
                  Get.back();
                },
                child: Column(
                  children: [
                    AppAvatar(
                      url: av.$2,
                      size: 52,
                      borderWidth: 0,
                      name: av.$1,
                    ),
                    const SizedBox(height: 6),
                    Text(av.$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(showBack: true, avatarUrl: _selectedAvatarUrl),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Manage your personal information and volunteering interests.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _changeAvatarDialog,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 3),
                          ),
                          child: AppAvatar(
                            url: _selectedAvatarUrl,
                            size: 120,
                            borderWidth: 0,
                            name: _nameController.text,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Profile Photo', style: Theme.of(context).textTheme.labelMedium),
                  Text('Select default avatars or tap upload.', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                  TextButton(
                    onPressed: _changeAvatarDialog, 
                    child: const Text('Change Photo')
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _field(context, 'Full Name', _nameController),
            const SizedBox(height: 16),
            _field(context, 'Email Address', _emailController, enabled: false),
            const SizedBox(height: 16),
            Text('Skills & Interests', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((s) => Chip(
                label: Text(s),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => setState(() => _skills.remove(s)),
                backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popular.map((s) => ActionChip(
                label: Text(s),
                onPressed: () => setState(() => _skills.add(s)),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text('Bio / Impact Goal', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your motivation for volunteering...',
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => PrimaryGradientButton(
              label: 'Save Changes',
              isLoading: AuthController.to.isLoading.value,
              onPressed: () {
                AuthController.to.updateProfile(
                  _nameController.text,
                  _bioController.text,
                  avatarUrl: _selectedAvatarUrl,
                );
              },
            )),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        IconTextField(
          controller: controller, 
          icon: label.contains('Email') ? Icons.mail_outline : Icons.person_outline,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        showBack: true,
        title: 'Settings',
        leading: Row(
          children: [
            const SizedBox(width: 4),
            const AppLogo(width: 32, height: 32),
            const SizedBox(width: 12),
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Get.toNamed(AppRoutes.editProfile)),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Preferences'),
            _toggleTile('Dark Mode', _darkMode, (v) {
              setState(() => _darkMode = v);
              Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
            }),
            const SizedBox(height: 12),
            _toggleTile('Notifications', _notifications, (v) => setState(() => _notifications = v)),
            const SizedBox(height: 24),
            _sectionHeader('Localization'),
            _linkTile('Language', 'English (US)', onTap: _showLanguageDialog),
            const SizedBox(height: 24),
            _sectionHeader('Support & Legal'),
            _linkTile('Privacy Policy', null, onTap: _showPrivacyPolicy),
            const SizedBox(height: 12),
            _linkTile('About App', 'v2.4.0', onTap: _showAboutApp),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => AuthController.to.logout(),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text('A community-driven volunteer platform connecting people with meaningful causes.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Made with ❤️ by ImpactForge Foundation', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline, letterSpacing: 1.2)),
    );
  }

  Widget _toggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English (US)'),
              trailing: const Icon(Icons.check, color: AppColors.primary),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Language Selected',
                  'Application language is set to English (US).',
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              title: const Text('Hindi (India)'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Language Selected',
                  'Application language is set to Hindi (India).',
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'ImpactForge Foundation values your privacy. We store user contribution details, points tally, and submission uploads securely on our Firestore cloud server. No commercial telemetry or third-party marketing integration is present. Contact privacy@impactforge.in for queries.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutApp() {
    Get.dialog(
      AlertDialog(
        title: const Text('About ImpactForge', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 2.4.0', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('ImpactForge Foundation is a community-driven volunteer platform connecting passionate individuals with meaningful causes. The Volunteer Hub streamlines real-time task allocations, active tracking, evidence verification, and community impact growth dashboards.', style: TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _linkTile(String title, String? trailing, {VoidCallback? onTap}) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          Row(
            children: [
              if (trailing != null) Text(trailing, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }
}

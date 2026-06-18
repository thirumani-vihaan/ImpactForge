import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/task_submission_screen.dart';
import '../screens/impact_analytics_screen.dart';
import '../screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialTab = AppNavTab.home});

  final AppNavTab initialTab;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late AppNavTab _tab;

  @override
  void initState() {
    super.initState();
    _tab = Get.arguments is AppNavTab ? Get.arguments as AppNavTab : widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _tab.index,
        children: const [
          HomeDashboardContent(),
          TasksScreenContent(),
          TaskSubmissionScreenContent(),
          ImpactAnalyticsScreenContent(),
          ProfileScreenContent(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        current: _tab,
        onChanged: (tab) => setState(() => _tab = tab),
      ),
      floatingActionButton: _tab == AppNavTab.home
          ? FloatingActionButton(
              onPressed: () {
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Text(
                          'Quick Actions',
                          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select an option below to navigate directly.',
                          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search, color: AppColors.primary),
                          ),
                          title: const Text('Discover Tasks', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Find new ways to help the community'),
                          onTap: () {
                            Get.back();
                            setState(() => _tab = AppNavTab.tasks);
                          },
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.assignment_turned_in, color: AppColors.secondary),
                          ),
                          title: const Text('Submit Task Report', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Report details of your volunteer work'),
                          onTap: () {
                            Get.back();
                            setState(() => _tab = AppNavTab.submit);
                          },
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryContainer.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: AppColors.tertiary),
                          ),
                          title: const Text('View My Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Check your badges and levels'),
                          onTap: () {
                            Get.back();
                            setState(() => _tab = AppNavTab.profile);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void navigateToShell(AppNavTab tab) {
  Get.offAllNamed(AppRoutes.home, arguments: tab);
}

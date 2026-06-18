import 'package:get/get.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/impact_analytics_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/task_details_screen.dart';
import '../screens/task_submission_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const adminDashboard = '/admin-dashboard';
  static const taskDetails = '/task-details';
  static const taskSubmission = '/task-submission';
  static const editProfile = '/edit-profile';
  static const impactAnalytics = '/impact-analytics';
  static const leaderboard = '/leaderboard';
  static const settings = '/settings';

  static List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: home, page: () => const HomeDashboardScreen()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardScreen()),
    GetPage(name: taskDetails, page: () => const TaskDetailsScreen()),
    GetPage(name: taskSubmission, page: () => const TaskSubmissionScreen()),
    GetPage(name: editProfile, page: () => const EditProfileScreen()),
    GetPage(name: impactAnalytics, page: () => const ImpactAnalyticsScreen()),
    GetPage(name: leaderboard, page: () => const LeaderboardScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];
}

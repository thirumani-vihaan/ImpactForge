import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'services/firestore_service.dart';
import 'services/auth_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/leaderboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // IMPORTANT: AuthService initializes Firebase — must run first.
    // On Android it reads from google-services.json (no explicit options needed).
    // On Web it uses explicit FirebaseOptions with the web appId.
    final authService = Get.put(AuthService());
    await authService.init();

    // Now Firestore can be initialized (Firebase is ready)
    final firestoreService = Get.put(FirestoreService());
    await firestoreService.init();

    // Register state controllers
    Get.put(AuthController());
    Get.put(TaskController());
    Get.put(LeaderboardController());
  } catch (e) {
    // If init fails, still run the app — it will navigate to an error/login screen
    // rather than showing a black screen.
    debugPrint('App initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ImpactForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}

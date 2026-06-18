class AppConfig {
  static const String dbProvider = 'firebase'; // 'firebase' only — no local fallback

  // --- FIREBASE CONFIGURATION ---
  static const String firebaseApiKey = 'AIzaSyAZlv702-mVTEf-gUcdchgvQfn47yA4wuI';
  static const String firebaseAuthDomain = 'nayeankh.firebaseapp.com';
  static const String firebaseProjectId = 'nayeankh';
  static const String firebaseStorageBucket = 'nayeankh.firebasestorage.app';
  static const String firebaseMessagingSenderId = '252393594776';

  // Web appId (used only on Flutter Web)
  static const String firebaseWebAppId = '1:252393594776:web:9ab472902b0d3f364c55ed';
  // Android appId (from google-services.json)
  static const String firebaseAndroidAppId = '1:252393594776:android:24351a3834dbaea54c55ed';

  // OAuth Web Client ID (from Firebase Console > Auth > Sign-in methods > Google)
  static const String googleClientId = '252393594776-l1lddcb9rda31afqlo179opgd9gbpb0s.apps.googleusercontent.com';
}

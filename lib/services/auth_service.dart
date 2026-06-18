import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
import '../constants/app_config.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  late final fba.FirebaseAuth _auth;

  // Reactive user state — null means logged out
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // GoogleSignIn — clientId for Web, serverClientId for Android
  late final GoogleSignIn _googleSignIn;

  Future<AuthService> init() async {
    // --- Platform-aware Firebase initialization ---
    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        // On Web: must pass explicit FirebaseOptions with the WEB appId
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: AppConfig.firebaseApiKey,
            authDomain: AppConfig.firebaseAuthDomain,
            projectId: AppConfig.firebaseProjectId,
            storageBucket: AppConfig.firebaseStorageBucket,
            messagingSenderId: AppConfig.firebaseMessagingSenderId,
            appId: AppConfig.firebaseWebAppId,
          ),
        );
      } else {
        // On Android: google-services.json is processed by the Gradle plugin,
        // so we call initializeApp() without options — it reads from the file.
        await Firebase.initializeApp();
      }
    }

    _auth = fba.FirebaseAuth.instance;

    // Platform-aware GoogleSignIn:
    // - Web uses `clientId`
    // - Android uses `serverClientId` (the same OAuth web client ID)
    _googleSignIn = kIsWeb
        ? GoogleSignIn(clientId: AppConfig.googleClientId)
        : GoogleSignIn(serverClientId: AppConfig.googleClientId);

    // Listen to Firebase Auth state changes
    _auth.authStateChanges().listen((fba.User? firebaseUser) async {
      if (firebaseUser != null && firebaseUser.email != null) {
        final normalizedEmail = firebaseUser.email!.trim().toLowerCase();
        try {
          final profile =
              await FirestoreService.to.getUserProfile(normalizedEmail);
          if (profile != null) {
            // Update avatar to Google profile photo if available and current is placeholder
            if (firebaseUser.photoURL != null &&
                (profile.avatarUrl.isEmpty ||
                    profile.avatarUrl.contains('ui-avatars.com'))) {
              final updated =
                  profile.copyWith(avatarUrl: firebaseUser.photoURL!);
              await FirestoreService.to.saveUserProfile(updated);
              currentUser.value = updated;
            } else {
              currentUser.value = profile;
            }
          } else {
            // Create a default user profile keyed by email
            final newUser = UserModel(
              email: normalizedEmail,
              name: firebaseUser.displayName ??
                  normalizedEmail.split('@').first,
              role: 'volunteer',
              points: 0,
              level: 1,
              tasksCompletedCount: 0,
              timeDonatedHours: 0,
              bio: 'Bridging passion with purpose. Committed to making structured, measurable impact.',
              avatarUrl: firebaseUser.photoURL ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(firebaseUser.displayName ?? normalizedEmail.split('@').first)}&background=00685F&color=fff&size=256',
            );
            await FirestoreService.to.saveUserProfile(newUser);
            currentUser.value = newUser;
          }
        } catch (e) {
          Get.log('Error loading user profile in auth state changes: $e');
          currentUser.value = null;
        }
      } else {
        currentUser.value = null;
      }
    });

    return this;
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final lowerRole = role.toLowerCase();
    final String defaultAvatar =
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=00685F&color=fff&size=256';

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    final user = credential.user!;
    await user.updateDisplayName(name.trim());

    final newUser = UserModel(
      email: normalizedEmail,
      name: name.trim(),
      role: lowerRole,
      points: 0,
      level: 1,
      tasksCompletedCount: 0,
      timeDonatedHours: 0,
      bio: 'Bridging passion with purpose. Committed to making structured, measurable impact.',
      avatarUrl: defaultAvatar,
    );

    await FirestoreService.to.saveUserProfile(newUser);
    currentUser.value = newUser;
    return newUser;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    final credential = await _auth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    final profile =
        await FirestoreService.to.getUserProfile(credential.user!.email!);
    if (profile == null) {
      throw Exception('User profile not found. Please sign up first.');
    }
    currentUser.value = profile;
    return profile;
  }

  Future<UserModel> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In was cancelled.');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final fba.AuthCredential credential = fba.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;
    final normalizedEmail = firebaseUser.email!.trim().toLowerCase();

    final profile =
        await FirestoreService.to.getUserProfile(normalizedEmail);
    if (profile != null) {
      if (firebaseUser.photoURL != null &&
          (profile.avatarUrl.isEmpty ||
              profile.avatarUrl.contains('ui-avatars.com'))) {
        final updatedProfile =
            profile.copyWith(avatarUrl: firebaseUser.photoURL!);
        await FirestoreService.to.saveUserProfile(updatedProfile);
        currentUser.value = updatedProfile;
        return updatedProfile;
      }
      currentUser.value = profile;
      return profile;
    } else {
      final newUser = UserModel(
        email: normalizedEmail,
        name: firebaseUser.displayName ?? normalizedEmail.split('@').first,
        role: 'volunteer',
        points: 0,
        level: 1,
        tasksCompletedCount: 0,
        timeDonatedHours: 0,
        bio: 'Bridging passion with purpose. Committed to making structured, measurable impact.',
        avatarUrl: firebaseUser.photoURL ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(firebaseUser.displayName ?? normalizedEmail.split('@').first)}&background=00685F&color=fff&size=256',
      );
      await FirestoreService.to.saveUserProfile(newUser);
      currentUser.value = newUser;
      return newUser;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    currentUser.value = null;
  }

  Future<void> refreshProfile() async {
    if (currentUser.value != null) {
      final updated =
          await FirestoreService.to.getUserProfile(currentUser.value!.email);
      if (updated != null) {
        currentUser.value = updated;
      }
    }
  }

  Future<void> updateProfile({
    required String name,
    required String bio,
    String? avatarUrl,
  }) async {
    if (currentUser.value != null) {
      final updated = currentUser.value!.copyWith(
        name: name,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      await FirestoreService.to.saveUserProfile(updated);
      currentUser.value = updated;
    }
  }
}

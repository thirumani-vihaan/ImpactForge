import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _authService = AuthService.to;

  final isLoading = false.obs;

  // Expose current authenticated user reactively
  UserModel? get currentUser => _authService.currentUser.value;
  Rxn<UserModel> get rxCurrentUser => _authService.currentUser;

  /// Converts Firebase Auth exception codes to user-friendly messages
  String _friendlyError(Object e) {
    if (e is fba.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email. Please sign up.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid email or password. Please check your credentials.';
        case 'email-already-in-use':
          return 'An account already exists with this email. Please log in.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'user-disabled':
          return 'This account has been disabled. Contact support.';
        default:
          return e.message ?? 'Authentication failed. Please try again.';
      }
    }
    return e.toString().replaceAll('Exception:', '').trim();
  }

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter both email and password.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.login(email: email.trim(), password: password);
      Get.snackbar(
        'Welcome Back',
        'Namaste, ${user.name}!',
        backgroundColor: const Color(0xFF00685F),
        colorText: Colors.white,
      );

      if (user.role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        _friendlyError(e),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.loginWithGoogle();
      Get.snackbar(
        'Welcome Back',
        'Namaste, ${user.name}!',
        backgroundColor: const Color(0xFF00685F),
        colorText: Colors.white,
      );

      if (user.role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Failed',
        _friendlyError(e),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password, String role) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all the details.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password should be at least 6 characters.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
        role: role,
      );

      Get.snackbar(
        'Account Created',
        'Welcome ${user.name} to the community!',
        backgroundColor: const Color(0xFF00685F),
        colorText: Colors.white,
      );

      if (user.role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        _friendlyError(e),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> updateProfile(String name, String bio, {String? avatarUrl}) async {
    if (name.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Name cannot be empty.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authService.updateProfile(
        name: name.trim(),
        bio: bio.trim(),
        avatarUrl: avatarUrl,
      );
      Get.snackbar(
        'Success',
        'Profile updated successfully.',
        backgroundColor: const Color(0xFF00685F),
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        _friendlyError(e),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

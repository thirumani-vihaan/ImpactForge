import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    AuthController.to.login(
      _emailController.text,
      _passwordController.text,
    );
  }

  void _googleLogin() {
    AuthController.to.loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AtmosphericBackground(
        opacity: 0.15,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    borderRadius: 12,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 192,
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const AppLogo(width: 192),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ImpactForge',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Empowering communities through action',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email Address', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                        ),
                        const SizedBox(height: 4),
                        IconTextField(
                          controller: _emailController,
                          icon: Icons.mail_outline,
                          hint: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Password', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                            TextButton(
                              onPressed: () {
                                final email = _emailController.text.trim();
                                if (email.isEmpty) {
                                  Get.snackbar(
                                    'Forgot Password', 
                                    'Please enter your email address in the field above first.',
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Password Reset', 
                                    'A password reset link has been dispatched to $email.',
                                    backgroundColor: const Color(0xFF00685F),
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: Text('Forgot password?', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        IconTextField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppColors.outline),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Obx(() => PrimaryGradientButton(
                          label: 'Login',
                          onPressed: _login,
                          isLoading: AuthController.to.isLoading.value,
                        )),
                        const SizedBox(height: AppSpacing.sm),
                        const OrDivider(),
                        const SizedBox(height: AppSpacing.sm),
                        GoogleSignInButton(onPressed: _googleLogin),
                        const SizedBox(height: AppSpacing.lg),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.signup),
                                  child: Text(
                                    'Create Account',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BrandIdentityFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

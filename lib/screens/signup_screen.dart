import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'Volunteer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'ImpactForge',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AppAvatar(url: AppAssets.signupAvatar, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 24, AppSpacing.marginMobile, 48),
        child: Column(
          children: [
            SizedBox(width: 128, height: 128, child: Image.asset(AppAssets.logo, fit: BoxFit.contain)),
            const SizedBox(height: 16),
            Text('Join the Movement', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              'Empower lives and contribute to a better future.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full Name', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  IconTextField(controller: _nameController, icon: Icons.person_outline, hint: 'Enter your full name'),
                  const SizedBox(height: 16),
                  Text('Email Address', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  IconTextField(controller: _emailController, icon: Icons.mail_outline, hint: 'name@example.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  Text('Create Password', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  IconTextField(controller: _passwordController, icon: Icons.lock_outline, hint: 'Min. 8 characters', obscureText: true),
                  const SizedBox(height: 16),
                  Text('I am joining as...', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        _rolePill('Volunteer'),
                        _rolePill('Admin'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => PrimaryGradientButton(
                    label: 'Register',
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    isLoading: AuthController.to.isLoading.value,
                    onPressed: () {
                      AuthController.to.signUp(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _role,
                      );
                    },
                  )),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log In',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _trustStat(context, Icons.favorite, AppColors.primaryContainer, '12k+', 'Lives Changed')),
                const SizedBox(width: 16),
                Expanded(child: _trustStat(context, Icons.groups, AppColors.secondaryContainer, '500+', 'Volunteers')),
              ],
            ),
            const SizedBox(height: 24),
            const BrandIdentityFooter(opacity: 0.6),
          ],
        ),
      ),
    );
  }

  Widget _rolePill(String role) {
    final selected = _role == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              role,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? AppColors.onPrimary : AppColors.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _trustStat(BuildContext context, IconData icon, Color color, String value, String label) {
    return GlassCard(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline, letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

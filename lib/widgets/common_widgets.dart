import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

class AppSpacing {
  static const xs = 4.0;
  static const sm = 12.0;
  static const base = 8.0;
  static const md = 24.0;
  static const lg = 40.0;
  static const xl = 64.0;
  static const marginMobile = 16.0;
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width = 40, this.height, this.borderRadius = 8});

  final double width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        AppAssets.logo,
        width: width,
        height: height ?? width,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.bolt, size: width * 0.7, color: AppColors.primary),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.url, this.size = 40, this.borderWidth = 2, this.name});

  final String url;
  final double size;
  final double borderWidth;
  final String? name;

  @override
  Widget build(BuildContext context) {
    // Check if the URL is a ui-avatars URL. If so, parse name and render natively to avoid CORS block
    if (url.startsWith('https://ui-avatars.com/api/')) {
      final uri = Uri.tryParse(url);
      final displayName = uri?.queryParameters['name'] ?? name ?? 'V';
      final initials = _getInitials(displayName);
      
      Color bg = AppColors.primary;
      final bgParam = uri?.queryParameters['background'];
      if (bgParam != null) {
        if (bgParam == '00685F') {
          bg = AppColors.primary;
        } else if (bgParam == '316BF3') {
          bg = AppColors.secondary;
        } else if (bgParam == '825100') {
          bg = AppColors.tertiary;
        } else if (bgParam == 'BA1A1A') {
          bg = AppColors.error;
        } else {
          final parsedColor = int.tryParse('0xFF$bgParam');
          if (parsedColor != null) {
            bg = Color(parsedColor);
          }
        }
      }

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: AppColors.surfaceContainerLowest, width: borderWidth),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceContainerLowest, width: borderWidth),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            color: AppColors.secondaryContainer,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    final clean = fullName.trim().replaceAll('+', ' ');
    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'V';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}

class AtmosphericBackground extends StatelessWidget {
  const AtmosphericBackground({super.key, this.child, this.opacity = 0.2});

  final Widget? child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixedDim.withValues(alpha: opacity),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryFixedDim.withValues(alpha: opacity),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.border,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final BoxBorder? border;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white.withValues(alpha: 0.8) : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      padding: padding,
      child: child,
    );

    if (onTap == null) return card;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(borderRadius), child: card);
  }
}

class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
        ),
      ),
    );
  }
}

class BrandIdentityFooter extends StatelessWidget {
  const BrandIdentityFooter({super.key, this.opacity = 0.6});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Text(
            '80G | 12A & COMMUNITY REGISTERED',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'WWW.IMPACTFORGE.IN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceContainerLowest,
        side: const BorderSide(color: AppColors.outlineVariant),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20, height: 20, child: CustomPaint(painter: _GoogleLogoPainter())),
          const SizedBox(width: 12),
          Text(
            'Sign in with Google',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    canvas.drawArc(Rect.fromCircle(center: const Offset(12, 12), radius: 10), -0.5, 3.5, false,
        Paint()
          ..color = const Color(0xFF4285F4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawArc(Rect.fromCircle(center: const Offset(12, 12), radius: 10), 2.5, 1.5, false,
        Paint()
          ..color = const Color(0xFF34A853)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawArc(Rect.fromCircle(center: const Offset(12, 12), radius: 10), 4, 1.2, false,
        Paint()
          ..color = const Color(0xFFFBBC05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawArc(Rect.fromCircle(center: const Offset(12, 12), radius: 10), 5.2, 1.8, false,
        Paint()
          ..color = const Color(0xFFEA4335)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawRect(const Rect.fromLTWH(12, 10, 8, 4), Paint()..color = const Color(0xFF4285F4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title = 'ImpactForge',
    this.showBack = false,
    this.avatarUrl,
    this.onBack,
    this.actions,
    this.leading,
  });

  final String title;
  final bool showBack;
  final String? avatarUrl;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor: AppColors.surface.withValues(alpha: 0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack ?? () => Get.back(),
            )
          : null,
      automaticallyImplyLeading: showBack,
      title: leading ??
          Row(
            children: [
              const AppLogo(width: 40, height: 40),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant),
              onPressed: () {},
            ),
            if (avatarUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AppAvatar(url: avatarUrl!, size: 40),
              ),
          ],
    );
  }
}

enum AppNavTab { home, tasks, submit, impact, profile }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current, required this.onChanged});

  final AppNavTab current;
  final ValueChanged<AppNavTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(AppNavTab.home, Icons.home, 'Home'),
              _item(AppNavTab.tasks, Icons.assignment_outlined, 'Tasks'),
              _item(AppNavTab.submit, Icons.add_circle_outline, 'Submit'),
              _item(AppNavTab.impact, Icons.auto_graph_outlined, 'Impact'),
              _item(AppNavTab.profile, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(AppNavTab tab, IconData icon, String label) {
    final selected = current == tab;
    return GestureDetector(
      onTap: () => onChanged(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: selected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.8))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline)),
        ),
        Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.8))),
      ],
    );
  }
}

class IconTextField extends StatelessWidget {
  const IconTextField({
    super.key,
    required this.controller,
    required this.icon,
    this.hint,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(icon, size: 20, color: AppColors.outline),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                hintStyle: TextStyle(color: AppColors.outline),
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

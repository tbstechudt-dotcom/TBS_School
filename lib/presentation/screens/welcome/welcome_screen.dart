import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../config/routes.dart';
import '../../widgets/common/desktop_left_panel.dart';
import '../../widgets/common/screen_illustrations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: context.isDesktop
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  // ─── Mobile layout (existing design) ───────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                const Spacer(),
                _buildLogo(context, 180),
                SizedBox(height: 32.h),
                Text(
                  'SchoolPay',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryC(context),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Pay school fees with ease',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondaryC(context),
                  ),
                ),
                const Spacer(),
                _buildFeatureItem(
                  context: context,
                  icon: Icons.speed_rounded,
                  text: 'Quick & Easy Payments',
                  color: AppColors.cardPurple,
                  iconColor: AppColors.cardPurpleDark,
                ),
                SizedBox(height: 12.h),
                _buildFeatureItem(
                  context: context,
                  icon: Icons.security_rounded,
                  text: '100% Secure Transactions',
                  color: AppColors.cardGreen,
                  iconColor: AppColors.cardGreenDark,
                ),
                SizedBox(height: 12.h),
                _buildFeatureItem(
                  context: context,
                  icon: Icons.receipt_long_rounded,
                  text: 'Instant Digital Receipts',
                  color: AppColors.cardBlue,
                  iconColor: AppColors.cardBlueDark,
                ),
                const Spacer(),
                _buildSignInButton(context),
                SizedBox(height: 12.h),
                _buildCreateAccountButton(context),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Desktop layout (split-screen) ─────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left panel — dark branding
        Expanded(
          flex: 5,
          child: DesktopLeftPanel(
            headline: 'Welcome to SchoolPay',
            subtitle: 'Pay school fees with ease',
            centerContent: ScreenIllustrations.welcomeDark(size: 360),
          ),
        ),

        // Right panel — features + actions
        Expanded(
          flex: 5,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryC(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Get started with secure and hassle-free school fee payments.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondaryC(context),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    _buildFeatureItem(
                      context: context,
                      icon: Icons.speed_rounded,
                      text: 'Quick & Easy Payments',
                      color: AppColors.cardPurple,
                      iconColor: AppColors.cardPurpleDark,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      context: context,
                      icon: Icons.security_rounded,
                      text: '100% Secure Transactions',
                      color: AppColors.cardGreen,
                      iconColor: AppColors.cardGreenDark,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      context: context,
                      icon: Icons.receipt_long_rounded,
                      text: 'Instant Digital Receipts',
                      color: AppColors.cardBlue,
                      iconColor: AppColors.cardBlueDark,
                    ),
                    SizedBox(height: 40.h),
                    _buildSignInButton(context),
                    SizedBox(height: 12.h),
                    _buildCreateAccountButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Shared widgets ────────────────────────────────────────────────

  Widget _buildLogo(BuildContext context, double size) {
    return ScreenIllustrations.welcome(size: size);
  }

  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.signIn),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primary600],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            const Icon(Icons.login_rounded, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.signUp),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.person_add_rounded, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [BoxShadow(color: AppColors.shadowLight, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryC(context),
              ),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}
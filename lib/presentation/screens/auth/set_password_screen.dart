import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/auth_desktop_wrapper.dart';
import '../../widgets/common/screen_illustrations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  final String mobile;
  final bool isResetPassword;

  const SetPasswordScreen({
    super.key,
    required this.mobile,
    this.isResetPassword = false,
  });

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.isResetPassword) {
        // Reset password flow
        await ref.read(authProvider.notifier).resetPassword(
          mobile: widget.mobile,
          newPassword: _passwordController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(Routes.signIn);
        }
      } else {
        // Sign up flow - use completeAccountCreation to UPDATE existing parent record
        await ref.read(authProvider.notifier).completeAccountCreation(
          mobile: widget.mobile,
          password: _passwordController.text,
        );

        if (mounted) {
          context.go(Routes.studentSelection);
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        // Clean up exception prefix for user-friendly display
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: AuthDesktopWrapper(
        headline: 'Set Your Password',
        subtitle: 'Create a secure password for your account',
        centerContent: ScreenIllustrations.setPassword(size: 360, isDark: true),
        onBack: () => context.pop(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Header
                    _buildHeader(),

                    SizedBox(height: 32.h),

                    // Password Field
                    _buildPasswordField(),

                    SizedBox(height: 16.h),

                    // Confirm Password Field
                    _buildConfirmPasswordField(),

                    SizedBox(height: 16.h),

                    // Password Requirements
                    _buildPasswordRequirements(),

                    SizedBox(height: 32.h),

                    // Submit Button
                    _buildSubmitButton(),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isResetPassword ? 'Reset Password' : 'Set Password',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryC(context),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          widget.isResetPassword
              ? 'Create a new password for your account'
              : 'Create a secure password for your account',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondaryC(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondaryC(context),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textPrimaryC(context),
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textHintC(context),
            ),
            filled: true,
            fillColor: AppColors.cardBg(context),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderC(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderC(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF007DFC), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 22,
              color: AppColors.textHintC(context),
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _showPassword = !_showPassword),
              child: Icon(
                _showPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 22,
                color: AppColors.textHintC(context),
              ),
            ),
          ),
          onChanged: (_) => setState(() {}), // Trigger rebuild for requirements
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
              return 'Password must include at least one uppercase letter';
            }
            if (!RegExp(r'[a-z]').hasMatch(value)) {
              return 'Password must include at least one lowercase letter';
            }
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'Password must include at least one number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondaryC(context),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_showConfirmPassword,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textPrimaryC(context),
          ),
          decoration: InputDecoration(
            hintText: 'Re-enter your password',
            hintStyle: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textHintC(context),
            ),
            filled: true,
            fillColor: AppColors.cardBg(context),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderC(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderC(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF007DFC), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 22,
              color: AppColors.textHintC(context),
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
              child: Icon(
                _showConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 22,
                color: AppColors.textHintC(context),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cardPurple,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryC(context),
            ),
          ),
          SizedBox(height: 8.h),
          _buildRequirement('Be at least 8 characters', hasMinLength),
          _buildRequirement('Include uppercase & lowercase letters', hasUppercase && hasLowercase),
          _buildRequirement('Include at least one number', hasNumber),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isSatisfied) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isSatisfied ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
            size: 16,
            color: isSatisfied ? AppColors.success : AppColors.cardPurpleDark,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: isSatisfied ? AppColors.success : AppColors.textSecondaryC(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSetPassword,
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
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              Text(
                widget.isResetPassword ? 'Reset Password' : 'Create Account',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 22,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
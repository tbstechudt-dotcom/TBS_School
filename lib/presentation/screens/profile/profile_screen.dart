import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/common/app_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final selectedStudent = ref.watch(selectedStudentProvider);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s4),
        child: Column(
          children: [
            _buildProfileHeader(currentUser?.phone ?? '', selectedStudent?.name ?? ''),
            const SizedBox(height: AppSizes.s6),
            _buildMenuSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String phone, String studentName) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.s6),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary100,
            child: Text(
              studentName.isNotEmpty ? studentName[0].toUpperCase() : 'P',
              style: const TextStyle(
                fontSize: AppSizes.text3xl,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s4),
          Text(
            'Parent',
            style: const TextStyle(
              fontSize: AppSizes.textLg,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.s1),
          Text(
            phone,
            style: const TextStyle(
              fontSize: AppSizes.textSm,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s2, vertical: AppSizes.s2),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: AppSizes.textSm,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.swap_horiz_rounded,
                title: 'Switch Student',
                onTap: () => context.go(Routes.studentSelection),
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
                onTap: () {
                  // TODO: Implement notification settings
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: () {
                  // TODO: Implement change password
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Implement help
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'About',
                onTap: () {
                  // TODO: Implement about
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s4),
        AppCard(
          padding: EdgeInsets.zero,
          child: _buildMenuItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ),
        const SizedBox(height: AppSizes.s6),
        Center(
          child: Text(
            'Version 1.0.0',
            style: const TextStyle(
              fontSize: AppSizes.textXs,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s4,
          vertical: AppSizes.s4,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.s3),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSizes.textSm,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
              context.go(Routes.welcome);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

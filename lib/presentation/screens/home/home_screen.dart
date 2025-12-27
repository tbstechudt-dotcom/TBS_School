import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../config/routes.dart';
import '../../providers/student_provider.dart';
import '../../providers/fee_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/fee/fee_summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudent = ref.watch(selectedStudentProvider);
    final feeSummaryAsync = ref.watch(feeSummaryProvider);

    if (selectedStudent == null) {
      return const Center(child: Text('No student selected'));
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary700,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.s6, vertical: AppSizes.s4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              child: Text(
                                selectedStudent.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: AppSizes.text2xl,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.s4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedStudent.name,
                                    style: const TextStyle(
                                      fontSize: AppSizes.textXl,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s1),
                                  Text(
                                    '${selectedStudent.className ?? ''} | ${selectedStudent.admissionNumber}',
                                    style: TextStyle(
                                      fontSize: AppSizes.textSm,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () => context.go(Routes.studentSelection),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s6, vertical: AppSizes.s4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                feeSummaryAsync.when(
                  loading: () => const LoadingIndicator(),
                  error: (error, _) => Text('Error: $error'),
                  data: (summary) => FeeSummaryCard(summary: summary),
                ),

                const SizedBox(height: AppSizes.s6),

                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: AppSizes.textLg,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.s3),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.payment_rounded,
                        title: 'Pay Fees',
                        color: AppColors.primary500,
                        onTap: () => context.go(Routes.fees),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s3),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.history_rounded,
                        title: 'History',
                        color: AppColors.success,
                        onTap: () => context.go(Routes.paymentHistory),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.s3),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.notifications_rounded,
                        title: 'Alerts',
                        color: AppColors.warning,
                        onTap: () => context.go(Routes.notifications),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s3),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.person_rounded,
                        title: 'Profile',
                        color: AppColors.info,
                        onTap: () => context.go(Routes.profile),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.s6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Payments',
                      style: TextStyle(
                        fontSize: AppSizes.textLg,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(Routes.paymentHistory),
                      child: const Text('View All'),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.s2),

                Container(
                  padding: const EdgeInsets.all(AppSizes.s6),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    borderRadius: BorderRadius.circular(AppSizes.roundedXl),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                      'No recent payments',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.roundedXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.roundedXl),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.roundedXl),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: AppSizes.s2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppSizes.textSm,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

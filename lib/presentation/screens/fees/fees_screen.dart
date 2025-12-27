import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/fee_model.dart';
import '../../providers/fee_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/fee/fee_card.dart';

class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feesAsync = ref.watch(feesProvider);
    final selectedStudent = ref.watch(selectedStudentProvider);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(selectedStudent?.name ?? 'Fees'),
        centerTitle: true,
      ),
      body: feesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(feesProvider),
        ),
        data: (fees) {
          if (fees.isEmpty) {
            return _buildEmptyState();
          }

          final pendingFees = fees.where((f) =>
            f.status == FeeStatus.pending || f.status == FeeStatus.overdue
          ).toList();
          final paidFees = fees.where((f) => f.status == FeeStatus.paid).toList();

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: AppColors.bgPrimary,
                  child: const TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: 'Pending'),
                      Tab(text: 'Paid'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildFeesList(context, pendingFees),
                      _buildFeesList(context, paidFees),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeesList(BuildContext context, List<FeeModel> fees) {
    if (fees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: AppColors.gray300,
            ),
            const SizedBox(height: AppSizes.s4),
            const Text(
              'No fees found',
              style: TextStyle(
                fontSize: AppSizes.textBase,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s6, vertical: AppSizes.s4),
      itemCount: fees.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.s3),
      itemBuilder: (context, index) {
        final fee = fees[index];
        return FeeCard(
          fee: fee,
          onTap: () => context.push('/fees/${fee.id}'),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 48,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: AppSizes.s6),
            const Text(
              'No Fees Found',
              style: TextStyle(
                fontSize: AppSizes.textLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.s2),
            const Text(
              'There are no fees assigned to this student yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.textSm,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../config/routes.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  // Mock data for pending fees
  List<Map<String, dynamic>> get _mockPendingFees => [
    {
      'id': '1',
      'title': 'Tuition Fee',
      'subtitle': 'Uniform & Text Book',
      'amount': 15000,
      'dueDate': '10 July 2025',
      'status': 'Pending',
      'icon': 'receipt',
    },
    {
      'id': '2',
      'title': 'Bus Fee',
      'subtitle': 'Monthly Transport',
      'amount': 10000,
      'dueDate': '10 July 2025',
      'status': 'Pending',
      'icon': 'bus',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Header (Fixed)
            _buildHeader(context),
            const SizedBox(height: 24),
            // Pending Fee List
            Expanded(
              child: _mockPendingFees.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _mockPendingFees.length,
                      itemBuilder: (context, index) {
                        final fee = _mockPendingFees[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildPendingCard(context, fee),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF808087).withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0051C6).withValues(alpha: 0.75),
                    blurRadius: 1,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF1F2933),
              ),
            ),
          ),

          // Title
          const Text(
            'Pending',
            style: TextStyle(
              fontSize: AppSizes.sectionTitle,
              fontWeight: AppSizes.fontSemibold,
              color: AppColors.textPrimary,
            ),
          ),

          // Notification Button
          GestureDetector(
            onTap: () => context.push(Routes.notifications),
            child: Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF808087).withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: const Color(0xFF0051C6).withValues(alpha: 0.75),
                        blurRadius: 1,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: Color(0xFF1F2933),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 25,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bgSecondary, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context, Map<String, dynamic> fee) {
    return GestureDetector(
      onTap: () {
        // Navigate to fee details
        context.push(Routes.fees);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF808087).withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: const Color(0xFF0051C6).withValues(alpha: 0.75),
              blurRadius: 1,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Icon, Title/Subtitle, Amount/Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Orange Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    fee['icon'] == 'bus' ? Icons.directions_bus : Icons.description_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fee['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: AppSizes.fontNormal,
                          color: AppColors.textPrimary,
                          height: 1.47,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fee['subtitle'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: AppSizes.fontNormal,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fee['status'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: AppSizes.fontSemibold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '₹ ${_formatAmount(fee['amount'])}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: AppSizes.fontSemibold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom Row: Due Date and Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Due Date
                Row(
                  children: [
                    const Text(
                      'Due Date:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: AppSizes.fontNormal,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      fee['dueDate'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: AppSizes.fontNormal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // Arrow
                Transform.rotate(
                  angle: 3.14159,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000) {
      final thousands = amount ~/ 1000;
      final remainder = amount % 1000;
      if (remainder == 0) {
        return '$thousands,000';
      }
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return amount.toString();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                Icons.pending_actions_outlined,
                size: 48,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Pending Fees',
              style: TextStyle(
                fontSize: AppSizes.textLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All your fees are paid. Great job!',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/payment_model.dart';
import '../../providers/payment_provider.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Term 1', 'Term 2', 'Term 3'];

  // Mock data for preview (remove when real data is available)
  // Note: PaymentModel.amount returns 0 by default as actual amount comes from cart
  // Using a wrapper class to provide mock amounts for display
  List<_MockPayment> get _mockPayments => [
    _MockPayment(
      payment: PaymentModel(
        payId: 1,
        insId: 1,
        inscode: 'INS001',
        paydate: DateTime(2025, 7, 10, 18, 0),
        paystatus: 'C',
        paymethod: 'Visa **** 9918',
        createdat: DateTime(2025, 7, 10, 18, 0),
      ),
      mockAmount: 15500,
      mockFeeName: 'Tuition Fee',
    ),
    _MockPayment(
      payment: PaymentModel(
        payId: 2,
        insId: 1,
        inscode: 'INS001',
        paydate: DateTime(2025, 7, 10, 18, 0),
        paystatus: 'C',
        paymethod: 'Visa **** 9918',
        createdat: DateTime(2025, 7, 10, 18, 0),
      ),
      mockAmount: 10000,
      mockFeeName: 'Bus Fee',
    ),
    _MockPayment(
      payment: PaymentModel(
        payId: 3,
        insId: 1,
        inscode: 'INS001',
        paystatus: 'F',
        paymethod: 'Visa **** 9918',
        createdat: DateTime(2025, 7, 10, 18, 0),
      ),
      mockAmount: 1000,
      mockFeeName: 'Library Fee',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Custom Header
            _buildHeader(context),
            const SizedBox(height: 24),
            // Filter Tabs
            _buildFilterTabs(),
            const SizedBox(height: 24),
            // Transaction List
            Expanded(
              child: paymentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
                data: (payments) {
                  // Convert real payments to _MockPayment for unified handling
                  final List<_MockPayment> displayPayments = payments.isEmpty
                      ? _mockPayments
                      : payments.map((p) => _MockPayment(
                          payment: p,
                          mockAmount: p.amount,
                          mockFeeName: 'Fee Payment',
                        )).toList();

                  // Filter payments based on active filter
                  final filteredPayments = _filterPayments(displayPayments);

                  if (filteredPayments.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filteredPayments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildTransactionCard(filteredPayments[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_MockPayment> _filterPayments(List<_MockPayment> payments) {
    if (_activeFilter == 'All') return payments;
    // For mock data, we'll filter by index to simulate terms
    // In real implementation, you'd filter by actual term data
    return payments;
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
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
            child: Center(
              child: SvgPicture.asset(
                'assets/images/menu.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1F2933),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // Title
          const Text(
            'History',
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
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/notification.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1F2933),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 24,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
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

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: _filters.map((filter) {
          final isActive = _activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1F2933) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? Colors.transparent : AppColors.textSecondary,
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? AppSizes.fontMedium : AppSizes.fontNormal,
                    color: isActive ? const Color(0xFFFAFAFA) : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionCard(_MockPayment mockPayment) {
    final payment = mockPayment.payment;
    final isPaid = payment.status == PaymentStatus.success;
    final statusColor = isPaid ? AppColors.success : AppColors.error;
    final feeName = mockPayment.mockFeeName;

    return GestureDetector(
      onTap: () => context.push('/payment-history/${payment.id}'),
      child: Container(
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
            // Top Row: Icon, Fee Name, Card Info | Status, Amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                _buildTransactionIcon(feeName, isPaid),
                const SizedBox(width: 10),
                // Fee Name and Card Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feeName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: AppSizes.fontNormal,
                          color: AppColors.textPrimary,
                          height: 1.47,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Visa icon placeholder
                          Container(
                            width: 34,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F71),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Center(
                              child: Text(
                                'VISA',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            payment.paymentMethod ?? '**** 9918',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: AppSizes.fontNormal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status and Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isPaid ? 'Paid' : 'Failed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: AppSizes.fontSemibold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '₹ ${_formatAmount(mockPayment.mockAmount)}',
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
            // Bottom Row: Date, Time | Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and Time
                Row(
                  children: [
                    Text(
                      _formatDate(payment.paidAt ?? payment.createdAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: AppSizes.fontNormal,
                        color: AppColors.textSecondary,
                        height: 1.47,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(payment.paidAt ?? payment.createdAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: AppSizes.fontNormal,
                        color: AppColors.textSecondary,
                        height: 1.47,
                      ),
                    ),
                  ],
                ),
                // Arrow Icon
                Transform.rotate(
                  angle: 3.14159, // 180 degrees
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
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

  Widget _buildTransactionIcon(String feeName, bool isPaid) {
    final bgColor = isPaid ? AppColors.success : AppColors.error;
    IconData icon;

    if (feeName.toLowerCase().contains('tuition')) {
      icon = Icons.description_outlined;
    } else if (feeName.toLowerCase().contains('bus')) {
      icon = Icons.directions_bus_outlined;
    } else if (feeName.toLowerCase().contains('library')) {
      icon = Icons.close;
    } else {
      icon = Icons.receipt_outlined;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 24,
        color: Colors.white,
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '0';
    final parts = amount.toStringAsFixed(0).split('');
    final result = <String>[];
    for (int i = 0; i < parts.length; i++) {
      if (i > 0) {
        final posFromEnd = parts.length - i;
        if (posFromEnd == 3 || (posFromEnd > 3 && (posFromEnd - 3) % 2 == 0)) {
          result.add(',');
        }
      }
      result.add(parts[i]);
    }
    return result.join('');
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'pm' : 'am';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
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
              'No Payments Yet',
              style: TextStyle(
                fontSize: AppSizes.textLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.s2),
            const Text(
              'Your payment history will appear here once you make a payment.',
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

/// Helper class to wrap PaymentModel with mock display data
class _MockPayment {
  final PaymentModel payment;
  final double mockAmount;
  final String mockFeeName;

  _MockPayment({
    required this.payment,
    required this.mockAmount,
    required this.mockFeeName,
  });
}

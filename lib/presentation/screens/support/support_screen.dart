import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../providers/cart_provider.dart';
import '../../providers/institution_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/common/breadcrumb_bar.dart';
import '../../widgets/common/desktop_detail_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  int _openFaqIndex = 0;

  final List<Map<String, String>> _faqs = [
    {
      'question': "How do I pay my child's fees online?",
      'answer':
          "Go to the \"Fee Details\" page, review the pending dues, and click on the 'Pay Now' button. Choose your preferred payment method and complete the transaction.",
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept various payment methods including credit/debit cards, net banking, UPI, and digital wallets.',
    },
    {
      'question': 'Will I receive a receipt after payment?',
      'answer':
          'Yes, you can download and share the payment receipt from the payment history section after successful payment.',
    },
    {
      'question': 'What happens if I miss a payment due date?',
      'answer':
          'Late fees may apply if payment is not received by the due date. Please contact the school administration for assistance.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final institutionAsync = ref.watch(selectedStudentInstitutionProvider);
    return DesktopDetailScaffold(
      isNested: true,
      header: Column(
        children: [
          SizedBox(height: 16.h),
          _buildHeader(context),
          SizedBox(height: 16.h),
        ],
      ),
      toolbar: const BreadcrumbBar(currentLabel: 'Help & Support'),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.isDesktop ? EdgeInsets.all(24.r) : EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              // Contact School Card
              _buildContactCard(institutionAsync),
              SizedBox(height: 24.h),
              // FAQ's Title
              Text(
                "FAQ's",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryC(context),
                ),
              ),
              SizedBox(height: 12.h),
              // FAQ Items
              ..._faqs.asMap().entries.map((entry) {
                final index = entry.key;
                final faq = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildFaqItem(
                    question: faq['question']!,
                    answer: faq['answer']!,
                    isOpen: _openFaqIndex == index,
                    onToggle: () {
                      setState(() {
                        _openFaqIndex = _openFaqIndex == index ? -1 : index;
                      });
                    },
                  ),
                );
              }),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cartItemCount = ref.watch(cartItemCountProvider);
    final notificationCount = ref.watch(notificationCountProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          // Back Button - Dark theme
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iconButtonBg(context),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryC(context),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Get assistance',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondaryC(context),
                  ),
                ),
              ],
            ),
          ),
          // Student chip (desktop only)
          if (context.isDesktop) ...[
            _buildStudentChip(context),
            SizedBox(width: 12.w),
          ],
          // Cart Icon - Dark theme
          GestureDetector(
            onTap: () => context.push(Routes.cart),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iconButtonBg(context),
                shape: BoxShape.circle,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.white),
                  if (cartItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.iconButtonBg(context), width: 2),
                        ),
                        child: Text(
                          cartItemCount > 9 ? '9+' : '$cartItemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Notification Icon - Dark theme with badge
          GestureDetector(
            onTap: () => context.go(Routes.notifications),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iconButtonBg(context),
                shape: BoxShape.circle,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_outlined, size: 20, color: Colors.white),
                  if (notificationCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.iconButtonBg(context), width: 2),
                        ),
                        child: Text(
                          notificationCount > 9 ? '9+' : '$notificationCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentChip(BuildContext context) {
    final student = ref.watch(selectedStudentProvider);
    if (student == null) return const SizedBox.shrink();
    final parts = student.name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    final initials = parts.take(2).map((p) => p[0]).join().toUpperCase();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary,
          backgroundImage: (student.photoUrl != null && student.photoUrl!.isNotEmpty)
              ? NetworkImage(student.photoUrl!) : null,
          child: (student.photoUrl == null || student.photoUrl!.isEmpty)
              ? Text(initials, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700))
              : null,
        ),
        SizedBox(width: 8.w),
        Text(student.name, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryC(context))),
      ],
    );
  }

  Widget _buildContactCard(AsyncValue<dynamic> institutionAsync) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppColors.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.cardBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 26,
                  color: AppColors.cardBlueDark,
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                'Contact School',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryC(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Divider
          Container(
            height: 1,
            color: AppColors.borderC(context),
          ),
          SizedBox(height: 20.h),
          // Email Row
          _buildContactRow(
            icon: Icons.email_rounded,
            iconBg: AppColors.cardPurple,
            iconColor: AppColors.cardPurpleDark,
            label: 'Email',
            value: institutionAsync.when(
              data: (inst) => inst?.email ?? 'N/A',
              loading: () => 'Loading...',
              error: (_, __) => 'N/A',
            ),
          ),
          SizedBox(height: 16.h),
          // Phone Row
          _buildContactRow(
            icon: Icons.phone_rounded,
            iconBg: AppColors.cardGreen,
            iconColor: AppColors.cardGreenDark,
            label: 'Phone',
            value: institutionAsync.when(
              data: (inst) => inst?.phone ?? 'N/A',
              loading: () => 'Loading...',
              error: (_, __) => 'N/A',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHintC(context),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryC(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool isOpen,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(16.r),
          border: isOpen
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isOpen ? AppColors.shadowPurple : AppColors.shadowLight,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              // Question Row
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isOpen ? AppColors.cardPurple : AppColors.cardCyan,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 20,
                      color: isOpen ? AppColors.cardPurpleDark : AppColors.cardCyanDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isOpen ? FontWeight.w600 : FontWeight.w500,
                        color: AppColors.textPrimaryC(context),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isOpen ? AppColors.primary : AppColors.filterBg(context),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: isOpen ? Colors.white : AppColors.textHintC(context),
                    ),
                  ),
                ],
              ),
              // Answer (shown when open)
              if (isOpen) ...[
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.cardPurple.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    answer,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryC(context),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
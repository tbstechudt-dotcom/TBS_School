import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';
import '../../../data/models/institution_model.dart';
import '../../providers/student_provider.dart';
import '../../providers/drawer_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudent = ref.watch(selectedStudentProvider);
    final institutionAsync = ref.watch(selectedStudentWithInstitutionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Header with Menu and Notification
                    _buildHeader(context, ref),

                    const SizedBox(height: 20),

                    // School Info
                    _buildSchoolInfo(institutionAsync),

                    const SizedBox(height: 16),

                    // Total Outstanding Card
                    _buildOutstandingCard(),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActions(context),

                    const SizedBox(height: 24),

                    // Student Card
                    _buildStudentCard(context, selectedStudent),

                    const SizedBox(height: 24),

                    // Fees Due Header
                    _buildFeesDueHeader(context),

                    const SizedBox(height: 12),

                    // Fee Items
                    _buildFeeItem(
                      icon: Icons.description_outlined,
                      title: 'Term-1 Fee',
                      date: 'Sep 01, 2026',
                      amount: '₹ 9,000',
                      onTap: () => context.push(Routes.fees),
                    ),

                    const SizedBox(height: 12),

                    _buildFeeItem(
                      icon: Icons.directions_bus_outlined,
                      title: 'Bus Fee',
                      date: 'Sep 01, 2026',
                      amount: '₹ 10,000',
                      onTap: () => context.push(Routes.fees),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
          GestureDetector(
            onTap: () => openMainDrawer(ref),
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
                      color: const Color(0xFF007DFC),
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

  Widget _buildSchoolInfo(AsyncValue<InstitutionModel?> institutionAsync) {
    final institution = institutionAsync.valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // School Logo
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(5),
            child: CustomPaint(
              painter: _SchoolLogoPainter(),
            ),
          ),
          const SizedBox(width: 8),
          // School Name and Address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institution?.name ?? 'School Name',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2933),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  institution?.shortAddress ?? 'Address not available',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutstandingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF0051C6).withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  // Background Image (100% opacity)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/8e8997ca481f4def3991bd517dcbef8d057e52ee.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF007DFC).withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  // Color Overlay (#007DFC at 8% opacity)
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFF007DFC).withValues(alpha: 0.08),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total Outstanding Label
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF059669),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Total Outstanding',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1F2933),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Amount
                        const Text(
                          '₹ 15,000',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF005FCC),
                            height: 1.38,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Due Alert
                        Row(
                          children: [
                            const Text(
                              'Due by: Feb 15,2026',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1F2933),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.red[600],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Overlay Image (right side of card)
          Positioned(
            right: 5,
            top: -20,
            child: Image.asset(
              'assets/images/ad7c9055c0864b6266f670f3d2c34956f0ff7256.png',
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 140,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuickActionItem(
            icon: Icons.credit_card,
            iconColor: const Color(0xFF007DFC),
            label: 'Pay Fee',
            onTap: () => context.go(Routes.fees),
          ),
          _buildQuickActionItem(
            icon: Icons.schedule,
            iconColor: const Color(0xFFF59E0B),
            label: 'Upcoming',
            onTap: () => context.push(Routes.pending),
          ),
          _buildQuickActionItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF2DBE60),
            label: 'Paid',
            onTap: () => context.push(Routes.paid),
          ),
          _buildQuickActionItem(
            icon: Icons.support_agent,
            iconColor: const Color(0xFF005FCC),
            label: 'Support',
            onTap: () => context.push(Routes.support),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
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
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1F2933),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, dynamic selectedStudent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        child: Row(
          children: [
            // Student Photo
            ClipOval(
              child: selectedStudent?.photoUrl != null && selectedStudent!.photoUrl!.isNotEmpty
                  ? Image.network(
                      selectedStudent.photoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5E7EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Color(0xFF6B7280),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedStudent?.name ?? 'Robert',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2933),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Admn No: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        selectedStudent?.admissionNumber ?? '3562756',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1F2933),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Class: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        selectedStudent?.className ?? '10-B',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1F2933),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 18,
                        color: const Color(0xFFAAD4FD),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Blood Group: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        selectedStudent?.stubloodgrp ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1F2933),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Swap Icon
            GestureDetector(
              onTap: () => context.go(Routes.studentSelection),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  size: 24,
                  color: Color(0xFF007DFC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeesDueHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Fees Due',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2933),
            ),
          ),
          GestureDetector(
            onTap: () => context.push(Routes.pending),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF007DFC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
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
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9CE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 8),

              // Title and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2933),
                        height: 1.47,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount and Arrow
              Row(
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2933),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: Color(0xFF6B7280),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// Custom painter for school logo
class _SchoolLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF007DFC)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Draw V shape
    path.moveTo(size.width * 0.5, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../config/routes.dart';

class StudentSelectionScreen extends ConsumerStatefulWidget {
  const StudentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsByParentProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Top Navigation - Back Button
            _buildTopNavigation(),
            const SizedBox(height: 32),
            // Header with Title and Illustration
            _buildHeader(),
            const SizedBox(height: 56),
            // Student List
            Expanded(
              child: _buildStudentList(),
            ),
            // Continue Button
            _buildContinueButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3D75FC).withValues(alpha: 0.24),
                    blurRadius: 1,
                    offset: Offset.zero,
                  ),
                  const BoxShadow(
                    color: Color(0xFFE5E7EB),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF1F2933),
                ),
              ),
            ),
          ),
          // Empty space for balance (no filter button in design)
          const SizedBox(width: 44),
        ],
      ),
      body: SafeArea(
        child: studentsAsync.when(
          loading: () => const LoadingIndicator(),
          error: (error, stack) => AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(studentsByParentProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _mockStudents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final student = _mockStudents[index];
        final isSelected = _selectedStudentId == student['id'];
        return _buildStudentCard(student, isSelected);
      },
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, bool isSelected) {
    final isPending = student['status'] == 'Pending';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStudentId = student['id'];
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
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
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF0051C6).withValues(alpha: 0.35),
                    blurRadius: 1,
                    offset: Offset.zero,
                  ),
                  BoxShadow(
                    color: const Color(0xFF0051C6).withValues(alpha: 0.2),
                    blurRadius: 2,
                    offset: Offset.zero,
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio Button
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: isSelected
                  ? Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1F2933),
                          width: 2,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Admission No.
                  const Text(
                    'Admission No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['admissionNo'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF1F2933),
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Name and Class Row
                  Row(
                    children: [
                      const Text(
                        'Name :',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        student['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1F2933),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '|',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2933),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Class :',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        student['class'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1F2933),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPending
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF2DBE60),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                student['status'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: AppSizes.fontSemibold,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: _selectedStudentId != null
            ? () {
                // Navigate to home screen
                context.go(Routes.home);
              }
            : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _selectedStudentId != null
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3D75FC).withValues(alpha: 0.24),
                blurRadius: 1,
                offset: Offset.zero,
              ),
              const BoxShadow(
                color: Color(0xFFE5E7EB),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: AppSizes.fontSemibold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward,
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Mock student data for preview
  final List<Map<String, dynamic>> _mockStudents = [
    {
      'id': '1',
      'name': 'Robert',
      'class': 'Class 10-B',
      'rollNo': '24',
      'adminNo': '3562756',
      'gender': 'Male',
      'dob': '19 Jul 2015',
      'blood': 'B+',
      'parent': 'Cameron',
      'mobile': '+91 95555 66270',
      'email': 'ziar@gmail.com',
      'address': '2715 Ash Dr. San Jose, South Dakota 83475',
    },
    {
      'id': '2',
      'name': 'Emma Johnson',
      'class': 'Class 10-B',
      'rollNo': '12',
      'adminNo': '3562801',
      'gender': 'Female',
      'dob': '15 Mar 2015',
      'blood': 'A+',
      'parent': 'Michael Johnson',
      'mobile': '+91 98765 43210',
      'email': 'emma.j@gmail.com',
      'address': '1234 Oak Street, Mumbai, Maharashtra 400001',
    },
  ];

  int _currentStudentIndex = 0;

  Map<String, dynamic> get _currentStudent => _mockStudents[_currentStudentIndex];

  void _swapStudent() {
    setState(() {
      _currentStudentIndex = (_currentStudentIndex + 1) % _mockStudents.length;
    });
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedStudent = ref.watch(selectedStudentProvider);

    // Use real data if available, otherwise use mock data
    final studentData = selectedStudent != null
        ? {
            'name': selectedStudent.name,
            'class': selectedStudent.className,
            'rollNo': 'N/A',
            'adminNo': selectedStudent.admissionNumber,
            'gender': selectedStudent.gender,
            'dob': _formatDate(selectedStudent.dateOfBirth),
            'blood': selectedStudent.stubloodgrp ?? 'N/A',
            'parent': 'N/A',
            'mobile': selectedStudent.mobile,
            'email': selectedStudent.email ?? 'N/A',
            'address': selectedStudent.fullAddress.isNotEmpty ? selectedStudent.fullAddress : 'N/A',
          }
        : _currentStudent;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Custom Header (Fixed)
            _buildHeader(context),
            const SizedBox(height: 24),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header with Photo
                    _buildProfileHeader(studentData),
                    const SizedBox(height: 24),
                    // Student Information Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildStudentInfoCard(studentData),
                    ),
                    const SizedBox(height: 24),
                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildLogoutButton(context),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
          GestureDetector(
            onTap: () {
              // Open drawer or menu
            },
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

          // Title
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: AppSizes.sectionTitle,
              fontWeight: AppSizes.fontSemibold,
              color: AppColors.textPrimary,
            ),
          ),

          // Notification Button
          GestureDetector(
            onTap: () => context.go(Routes.notifications),
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

  Widget _buildProfileHeader(Map<String, dynamic> student) {
    return Column(
      children: [
        // Profile Photo with Camera Button
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary100,
                image: DecorationImage(
                  image: AssetImage('assets/images/ac3f89ecafb3264080adf69735576d5fd8eb7967.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: student['name'] != null
                  ? null
                  : Center(
                      child: Text(
                        (student['name'] as String?)?.isNotEmpty == true
                            ? student['name'][0].toUpperCase()
                            : 'P',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            // Camera Button
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Handle photo edit
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgSecondary, width: 2),
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
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Student Name
        Text(
          student['name'] ?? 'Student',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: AppSizes.fontSemibold,
            color: AppColors.textPrimary,
            height: 1.27,
          ),
        ),
        const SizedBox(height: 5),
        // Class and Roll Number
        Text(
          '${student['class']} | Roll No: ${student['rollNo']}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: AppSizes.fontNormal,
            color: AppColors.textSecondary,
            height: 1.47,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentInfoCard(Map<String, dynamic> student) {
    final infoRows = [
      {'label': 'Admn No.', 'value': student['adminNo']},
      {'label': 'Gender', 'value': student['gender']},
      {'label': 'DOB', 'value': student['dob']},
      {'label': 'Blood', 'value': student['blood']},
      {'label': 'Parent', 'value': student['parent']},
      {'label': 'Mobile', 'value': student['mobile']},
      {'label': 'Email', 'value': student['email']},
      {'label': 'Address', 'value': student['address']},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Swap button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Student Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: AppSizes.fontSemibold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _swapStudent,
                child: const Row(
                  children: [
                    Icon(
                      Icons.swap_horiz,
                      size: 24,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Swap',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: AppSizes.fontNormal,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFC6DDFF),
          ),
          const SizedBox(height: 16),
          // Info Rows
          ...infoRows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 82,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          row['label']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: AppSizes.fontNormal,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row['value'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: AppSizes.fontNormal,
                          color: AppColors.textPrimary,
                          height: 1.47,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD1CF),
          borderRadius: BorderRadius.circular(8),
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: AppSizes.fontSemibold,
                color: Color(0xFFDC2626),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.logout,
              size: 24,
              color: Color(0xFFDC2626),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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

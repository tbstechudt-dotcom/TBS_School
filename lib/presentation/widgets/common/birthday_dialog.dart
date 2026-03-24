import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthdayDialog extends StatefulWidget {
  final String studentName;
  final VoidCallback onDismiss;

  const BirthdayDialog({
    super.key,
    required this.studentName,
    required this.onDismiss,
  });

  @override
  State<BirthdayDialog> createState() => _BirthdayDialogState();
}

class _BirthdayDialogState extends State<BirthdayDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Start animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // The dialog card
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: AppColors.cardBg(context),
              insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cake icon
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: AppColors.cardOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '\u{1F382}',
                          style: TextStyle(fontSize: 44.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // "Happy Birthday!" heading
                    Text(
                      'Happy Birthday! \u{1F389}',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryC(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),

                    // Personalized message
                    Text(
                      'Wishing you a wonderful birthday, ${widget.studentName}! '
                      'May this year bring you great success and happiness.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryC(context),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // Party emoji row
                    Text(
                      '\u{1F388}\u{1F381}\u{1F38A}',
                      style: TextStyle(fontSize: 28.sp),
                    ),
                    SizedBox(height: 24.h),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: widget.onDismiss,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Thank You! \u{1F973}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFF22C55E),
              Color(0xFFF59E0B),
              Color(0xFFEF4444),
              Color(0xFF3B82F6),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
              Color(0xFFF97316),
            ],
            numberOfParticles: 30,
            gravity: 0.1,
            emissionFrequency: 0.05,
            maxBlastForce: 20,
            minBlastForce: 8,
          ),
        ),
      ],
    );
  }
}
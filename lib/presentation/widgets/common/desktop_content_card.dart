import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable card container for desktop dashboard content sections.
///
/// Wraps content in a rounded card with consistent padding, border radius,
/// and subtle shadow. Used on desktop to create the "padded dashboard" look.
///
/// Usage:
///   DesktopContentCard(child: myWidget)
///   DesktopContentCard(title: 'Fee Status', trailing: viewAllBtn, child: table)
///   DesktopContentCard(hasPadding: false, child: fullWidthTable)
class DesktopContentCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final bool hasPadding;

  const DesktopContentCard({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.padding,
    this.hasPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppColors.cardShadow(context),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryC(context),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
          if (hasPadding)
            Padding(
              padding: padding ?? EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.h),
              child: child,
            )
          else
            child,
        ],
      ),
    );
  }
}

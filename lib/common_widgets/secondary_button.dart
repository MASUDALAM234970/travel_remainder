import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? iconWidget; // Image, Icon, Svg সব support করবে
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.iconWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || isLoading;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.4),
            width: 1.5.w,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (iconWidget != null) ...[
                      iconWidget!,
                      SizedBox(width: 8.w),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

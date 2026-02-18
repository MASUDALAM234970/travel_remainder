import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || isLoading;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: disabled
                ? [
              AppColors.primary.withOpacity(0.5),
              AppColors.primaryDark.withOpacity(0.5),
            ]
                : [
              AppColors.primaryLight,
              AppColors.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: !disabled
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            width: 24.r,
            height: 24.r,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
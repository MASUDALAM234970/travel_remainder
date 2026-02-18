import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class LocationField extends StatelessWidget {
  final String locationText;
  final VoidCallback? onTap;

  const LocationField({
    super.key,
    required this.locationText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = locationText.isEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: !isEmpty
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: !isEmpty
                  ? AppColors.primary
                  : AppColors.textHint,
              size: 24.sp,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Text(
                isEmpty ? 'Add your location' : locationText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: isEmpty
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                  fontWeight:
                  isEmpty ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),

            if (!isEmpty)
              Icon(
                Icons.edit_outlined,
                color: AppColors.textHint.withOpacity(0.6),
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
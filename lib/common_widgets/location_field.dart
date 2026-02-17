import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: locationText.isNotEmpty
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: locationText.isNotEmpty
                  ? AppColors.primary
                  : AppColors.textHint,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                locationText.isEmpty ? 'Add your location' : locationText,
                style: locationText.isEmpty
                    ? AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textHint,
                      )
                    : AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (locationText.isNotEmpty)
              Icon(
                Icons.edit_outlined,
                color: AppColors.textHint.withOpacity(0.6),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../constants/app_colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              data.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  'Image not found: ${data.image}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.redAccent,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              data.title,
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

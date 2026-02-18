

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/primary_button.dart';
import '../../../common_widgets/secondary_button.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Expanded(
              //   flex: 5,
              //   child: _buildImageSection(),
              // ),
              Expanded(flex: 5, child: _buildContentSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildImageSection() {
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       ClipRRect(
  //         borderRadius: const BorderRadius.only(
  //           bottomLeft: Radius.circular(32),
  //           bottomRight: Radius.circular(32),
  //         ),
  //         child: _buildRoadSceneImage(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome! Your Smart\nTravel Alarm',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Stay on schedule and enjoy every moment of your journey.',
            style: AppTextStyles.bodyLarge,
          ),
          SizedBox(height: 50),
          Image.asset("assets/images/location_one.png"),
          SizedBox(height: 60),
          // Error message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Text(
                  controller.errorMessage.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Location status + loading
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Fetching current location...",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.hasLocation.value) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Selected Location: ${controller.locationText.value}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Not loading + not selected
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_off,
                    color: Colors.white.withOpacity(0.75),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Location not selected yet.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          Obx(() => SecondaryButton(
            text: controller.hasLocation.value
                ? 'Use Current Location'
                : 'Use Current Location',
            iconWidget: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "assets/images/location-05.png",
                width: 24,
                height: 24,
              ),
            ),
            onTap: controller.isLoading.value
                ? null
                : controller.useCurrentLocation,
            isLoading: controller.isLoading.value,
          )),

                 SizedBox(height: 15,),
          // Home button disabled until location fetched
          Obx(
            () => PrimaryButton(
              text: 'Home',
              onTap: controller.hasLocation.value ? controller.goToHome : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

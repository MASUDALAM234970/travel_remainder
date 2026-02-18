import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/primary_button.dart';
import 'widgets/onboarding_page_widget.dart';
import 'widgets/page_indicator.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: AppConstants.onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                data: AppConstants.onboardingData[index],
              );
            },
          ),

          // Skip Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 24,
            child: GestureDetector(
              onTap: controller.skipOnboarding,
              child:  Text(
                'Skip',
                style: AppTextStyles.skipButton,
              ),
            ),
          ),

          // Bottom content: indicator + button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicator
                  Obx(() => PageIndicator(
                        count: AppConstants.onboardingData.length,
                        currentIndex: controller.currentPage.value,
                      )),
                  const SizedBox(height: 32),

                  // Next Button
                  PrimaryButton(
                    text: 'Next',
                    onTap: controller.nextPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

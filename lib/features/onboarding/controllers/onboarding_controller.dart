import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final int totalPages = 3;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToLocation();
    }
  }

  void skipOnboarding() {
    goToLocation();
  }

  void goToLocation() {
    Get.offNamed(AppRoutes.location);
  }

  bool get isLastPage => currentPage.value == totalPages - 1;
}

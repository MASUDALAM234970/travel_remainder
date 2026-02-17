import 'package:get/get.dart';
import '../features/onboarding/bindings/onboarding_binding.dart';
import '../features/onboarding/views/onboarding_view.dart';
import '../features/location/bindings/location_binding.dart';
import '../features/location/views/location_view.dart';
import '../features/alarm/bindings/alarm_binding.dart';
import '../features/alarm/views/alarm_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String location = '/location';
  static const String home = '/home';

  static final List<GetPage> pages = [
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: location,
      page: () => const LocationView(),
      binding: LocationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const AlarmView(),
      binding: AlarmBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

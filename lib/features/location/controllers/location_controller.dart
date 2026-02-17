import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  final hasLocation = false.obs;
  final errorMessage = ''.obs;
  final locationText = ''.obs;

  Future<void> useCurrentLocation() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1) Location service on?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Turn on Location (GPS) from settings.';
        await Geolocator.openLocationSettings();
        return;
      }

      // 2) Request permission (foreground)
      var status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        status = await Permission.locationWhenInUse.request();
      }

      if (status.isPermanentlyDenied) {
        errorMessage.value = 'Location permission permanently denied. Open settings.';
        await openAppSettings();
        return;
      }

      if (!status.isGranted) {
        errorMessage.value = 'Location permission denied.';
        return;
      }

      // 3) Get location
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      hasLocation.value = true;
      locationText.value = 'Lat: ${pos.latitude}, Lng: ${pos.longitude}';
    } catch (e) {
      errorMessage.value = 'Location error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goToHome() {
    Get.toNamed('/home'); // তোমার route নাম যদি /home হয়
  }
}
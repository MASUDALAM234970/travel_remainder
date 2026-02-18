// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LocationController extends GetxController {
//   final isLoading = false.obs;
//   final hasLocation = false.obs;
//   final errorMessage = ''.obs;
//   final locationText = ''.obs;
//
//   Future<void> useCurrentLocation() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     try {
//       // 1) Location service on?
//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         errorMessage.value = 'Turn on Location (GPS) from settings.';
//         await Geolocator.openLocationSettings();
//         return;
//       }
//
//       // 2) Request permission (foreground)
//       var status = await Permission.locationWhenInUse.status;
//       if (!status.isGranted) {
//         status = await Permission.locationWhenInUse.request();
//       }
//
//       if (status.isPermanentlyDenied) {
//         errorMessage.value = 'Location permission permanently denied. Open settings.';
//         await openAppSettings();
//         return;
//       }
//
//       if (!status.isGranted) {
//         errorMessage.value = 'Location permission denied.';
//         return;
//       }
//
//       // 3) Get location
//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       hasLocation.value = true;
//       locationText.value = 'Lat: ${pos.latitude}, Lng: ${pos.longitude}';
//     } catch (e) {
//       errorMessage.value = 'Location error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void goToHome() {
//     Get.toNamed('/home'); // তোমার route নাম যদি /home হয়
//   }
// }




// lib/app/modules/location/controllers/location_controller.dart

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  final hasLocation = false.obs;
  final errorMessage = ''.obs;
  final locationText = ''.obs;

  @override
  void onReady() {
    super.onReady();

    // ✅ Auto-call when screen opens (only if not already fetched)
    if (!hasLocation.value && !isLoading.value) {
      useCurrentLocation();
    }
  }

  Future<void> useCurrentLocation() async {
    if (isLoading.value) return;

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
        errorMessage.value =
        'Location permission permanently denied. Open settings.';
        await openAppSettings();
        return;
      }

      if (!status.isGranted) {
        errorMessage.value = 'Location permission denied.';
        return;
      }

      // 3) Get GPS position
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4) Convert lat/lng -> Address text
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      if (place == null) {
        hasLocation.value = true;
        locationText.value = 'Lat: ${pos.latitude}, Lng: ${pos.longitude}';
        return;
      }

      // ✅ Make a clean address (null-safe)
      final parts = <String?>[
        place.street,
      //  place.subLocality,
        place.locality,
     //   place.administrativeArea,
       // place.postalCode,
        place.country,
      ];

      final cleaned = parts
          .whereType<String>() // removes null
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      hasLocation.value = true;
      locationText.value = cleaned.isEmpty
          ? 'Lat: ${pos.latitude}, Lng: ${pos.longitude}'
          : cleaned.join(', ');
    } catch (e) {
      errorMessage.value = 'Location error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goToHome() {
    Get.toNamed('/home'); // change if your route differs
  }
}
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../constants/app_constants.dart';
import '../controllers/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}

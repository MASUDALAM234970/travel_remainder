import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../main.dart'; // Assuming this has global plugin if needed — but we use NotificationHelper now
import '../../../constants/app_constants.dart';
import '../../../helpers/notification_helper.dart';
import '../models/alarm_model.dart';

class AlarmController extends GetxController {
  final RxList<AlarmModel> alarms = <AlarmModel>[].obs;
  final RxString locationText = ''.obs;
  final RxBool isLoading = false.obs;

  late Box<AlarmModel> _alarmsBox;

  @override
  void onInit() {
    super.onInit();
    _loadLocation();
    _loadAlarms();
  }

  void _loadLocation() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      locationText.value = args['location'] ?? '';
    }
    if (locationText.value.isEmpty) {
      try {
        if (Hive.isBoxOpen(AppConstants.hiveLocationBox)) {
          final box = Hive.box(AppConstants.hiveLocationBox);
          final saved = box.get(AppConstants.locationKey);
          if (saved != null && saved is Map) {
            locationText.value = saved['address'] ?? '';
          }
        }
      } catch (_) {}
    }
  }

  void _loadAlarms() {
    try {
      _alarmsBox = Hive.box<AlarmModel>(AppConstants.hiveAlarmsBox);
      alarms.assignAll(_alarmsBox.values.toList());
    } catch (e) {
      alarms.clear();
    }
  }

  Future<void> addAlarm(DateTime dateTime) async {
    isLoading.value = true;
    try {
      final alarm = AlarmModel(
        id: const Uuid().v4(),
        dateTime: dateTime,
        isEnabled: true,
        location: locationText.value.isNotEmpty ? locationText.value : null,
      );

      await _alarmsBox.put(alarm.id, alarm);
      alarms.add(alarm);

      // Schedule real notification using the actual alarm data
      final locationBody = alarm.location != null && alarm.location!.isNotEmpty
          ? 'Time to prepare! Location: ${alarm.location}'
          : 'Your travel alarm is ringing!';

      await NotificationHelper.scheduleAlarmNotification(
        id: alarm.id.hashCode.abs(), // Ensure positive int (abs to avoid negatives)
        title: '⏰ Travel Alarm',
        body: locationBody,
        scheduledDate: alarm.dateTime,
        payload: alarm.id, // Use UUID as payload for handling tap if needed
      );

      // Optional debug (remove in production or wrap in if(kDebugMode))
      await NotificationHelper.debugPrintPending();

      Get.snackbar(
        'Alarm Set',
        'Scheduled for ${_formatTime(dateTime)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF5B2EFF).withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.alarm, color: Colors.white),
      );
    } catch (e) {
      print('Alarm scheduling error: $e'); // Log for debugging
      Get.snackbar(
        'Error',
        'Failed to set alarm: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAlarm(AlarmModel alarm) async {
    try {
      final index = alarms.indexWhere((a) => a.id == alarm.id);
      if (index == -1) return;

      final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
      await _alarmsBox.put(updatedAlarm.id, updatedAlarm);
      alarms[index] = updatedAlarm;
      alarms.refresh();

      final notificationId = alarm.id.hashCode.abs(); // Consistent ID

      if (updatedAlarm.isEnabled) {
        final locationBody = updatedAlarm.location != null && updatedAlarm.location!.isNotEmpty
            ? 'Time to prepare! Location: ${updatedAlarm.location}'
            : 'Your travel alarm is ringing!';

        await NotificationHelper.scheduleAlarmNotification(
          id: notificationId,
          title: '⏰ Travel Alarm',
          body: locationBody,
          scheduledDate: updatedAlarm.dateTime,
          payload: updatedAlarm.id,
        );
      } else {
        await NotificationHelper.cancelNotification(id: notificationId);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update alarm: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAlarm(AlarmModel alarm) async {
    try {
      await _alarmsBox.delete(alarm.id);
      alarms.removeWhere((a) => a.id == alarm.id);

      await NotificationHelper.cancelNotification(id: alarm.id.hashCode.abs());

      Get.snackbar(
        'Deleted',
        'Alarm removed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete alarm: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  void updateLocation(String location) {
    locationText.value = location;
  }
}
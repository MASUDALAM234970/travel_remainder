// // lib/features/alarm/controllers/alarm_controller.dart
// //
// // ✅ Fixes included:
// // 1) Location now persists to Hive when you update/select/search location
// // 2) _loadLocation() can read from Get.arguments OR Hive (even if box wasn't open yet)
// // 3) Nominatim search uses proper headers + safe parsing
// // 4) Utility: clearSuggestions()
// // 5) No Google key required (OpenStreetMap / Nominatim)
//
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
//
// import '../../../constants/app_constants.dart';
// import '../../../helpers/notification_helper.dart';
// import '../models/alarm_model.dart';
//
// class AlarmController extends GetxController {
//   final RxList<AlarmModel> alarms = <AlarmModel>[].obs;
//
//   /// Current selected location text shown on UI
//   final RxString locationText = ''.obs;
//
//   /// Loading for adding alarm
//   final RxBool isLoading = false.obs;
//
//   /// Search state for location dialog suggestions
//   final suggestions = <Map<String, dynamic>>[].obs;
//   final isSearching = false.obs;
//
//   late Box<AlarmModel> _alarmsBox;
//   late Box _locationBox;
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//
//     await _ensureHiveBoxes();
//
//     _loadLocation(); // now safe (box ensured)
//     _loadAlarms();
//   }
//
//   Future<void> _ensureHiveBoxes() async {
//     // Alarms box (typed)
//     if (!Hive.isBoxOpen(AppConstants.hiveAlarmsBox)) {
//       _alarmsBox = await Hive.openBox<AlarmModel>(AppConstants.hiveAlarmsBox);
//     } else {
//       _alarmsBox = Hive.box<AlarmModel>(AppConstants.hiveAlarmsBox);
//     }
//
//     // Location box (dynamic)
//     if (!Hive.isBoxOpen(AppConstants.hiveLocationBox)) {
//       _locationBox = await Hive.openBox(AppConstants.hiveLocationBox);
//     } else {
//       _locationBox = Hive.box(AppConstants.hiveLocationBox);
//     }
//   }
//
//   void _loadLocation() {
//     // 1) read from route arguments (highest priority)
//     final args = Get.arguments;
//     if (args != null && args is Map) {
//       final argLoc = args['location'];
//       if (argLoc != null) {
//         locationText.value = argLoc.toString().trim();
//       }
//     }
//
//     // 2) if empty, read from Hive saved location
//     if (locationText.value.isEmpty) {
//       try {
//         final saved = _locationBox.get(AppConstants.locationKey);
//         if (saved is Map) {
//           final address = saved['address'];
//           if (address != null) {
//             locationText.value = address.toString().trim();
//           }
//         } else if (saved is String) {
//           // if you ever saved as plain string
//           locationText.value = saved.trim();
//         }
//       } catch (_) {}
//     }
//   }
//
//   void _loadAlarms() {
//     try {
//       alarms.assignAll(_alarmsBox.values.toList());
//     } catch (_) {
//       alarms.clear();
//     }
//   }
//
//   // -------------------- Alarm CRUD --------------------
//
//   Future<void> addAlarm(DateTime dateTime) async {
//     isLoading.value = true;
//     try {
//       final alarm = AlarmModel(
//         id: const Uuid().v4(),
//         dateTime: dateTime,
//         isEnabled: true,
//         location: locationText.value.isNotEmpty ? locationText.value : null,
//       );
//
//       await _alarmsBox.put(alarm.id, alarm);
//       alarms.add(alarm);
//
//       final locationBody =
//       (alarm.location != null && alarm.location!.isNotEmpty)
//           ? 'Time to prepare! Location: ${alarm.location}'
//           : 'Your travel alarm is ringing!';
//
//       await NotificationHelper.scheduleAlarmNotification(
//         id: alarm.id.hashCode.abs(),
//         title: '⏰ Travel Alarm',
//         body: locationBody,
//         scheduledDate: alarm.dateTime,
//         payload: alarm.id,
//       );
//
//       if (kDebugMode) {
//         await NotificationHelper.debugPrintPending();
//       }
//
//       Get.snackbar(
//         'Alarm Set',
//         'Scheduled for ${_formatTime(dateTime)}',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: const Color(0xFF5B2EFF).withOpacity(0.9),
//         colorText: Colors.white,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//         icon: const Icon(Icons.alarm, color: Colors.white),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         // ignore: avoid_print
//         print('Alarm scheduling error: $e');
//       }
//       Get.snackbar(
//         'Error',
//         'Failed to set alarm: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent.withOpacity(0.9),
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> toggleAlarm(AlarmModel alarm) async {
//     try {
//       final index = alarms.indexWhere((a) => a.id == alarm.id);
//       if (index == -1) return;
//
//       final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
//       await _alarmsBox.put(updatedAlarm.id, updatedAlarm);
//       alarms[index] = updatedAlarm;
//       alarms.refresh();
//
//       final notificationId = alarm.id.hashCode.abs();
//
//       if (updatedAlarm.isEnabled) {
//         final locationBody =
//         (updatedAlarm.location != null && updatedAlarm.location!.isNotEmpty)
//             ? 'Time to prepare! Location: ${updatedAlarm.location}'
//             : 'Your travel alarm is ringing!';
//
//         await NotificationHelper.scheduleAlarmNotification(
//           id: notificationId,
//           title: '⏰ Travel Alarm',
//           body: locationBody,
//           scheduledDate: updatedAlarm.dateTime,
//           payload: updatedAlarm.id,
//         );
//       } else {
//         await NotificationHelper.cancelNotification(id: notificationId);
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to update alarm: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent.withOpacity(0.9),
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> deleteAlarm(AlarmModel alarm) async {
//     try {
//       await _alarmsBox.delete(alarm.id);
//       alarms.removeWhere((a) => a.id == alarm.id);
//
//       await NotificationHelper.cancelNotification(id: alarm.id.hashCode.abs());
//
//       Get.snackbar(
//         'Deleted',
//         'Alarm removed',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.grey.withOpacity(0.9),
//         colorText: Colors.white,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to delete alarm: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent.withOpacity(0.9),
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   String _formatTime(DateTime dateTime) {
//     final hour = dateTime.hour;
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     final period = hour >= 12 ? 'pm' : 'am';
//     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
//     return '$displayHour:$minute $period';
//   }
//
//   // -------------------- Location: Save + Search --------------------
//
//   /// ✅ Call this when user types a custom location and presses Save
//   void updateLocation(String text) {
//     final v = text.trim();
//     locationText.value = v;
//
//     // ✅ Persist to Hive so next time it loads
//     try {
//       _locationBox.put(AppConstants.locationKey, {
//         'address': v,
//         'updatedAt': DateTime.now().toIso8601String(),
//       });
//     } catch (_) {}
//
//     // optional: close suggestions
//     suggestions.clear();
//   }
//
//   /// ✅ Nominatim (OpenStreetMap) search. No API key needed.
//   Future<void> searchLocations(String query) async {
//     final q = query.trim();
//
//     if (q.length < 3) {
//       suggestions.clear();
//       return;
//     }
//
//     isSearching.value = true;
//
//     try {
//       // ✅ Proper URL encoding
//       final uri = Uri.https('photon.komoot.io', '/api/', {
//         'q': q,
//         'limit': '8',
//       });
//
//       final res = await http
//           .get(uri, headers: const {'Accept': 'application/json'})
//           .timeout(const Duration(seconds: 8));
//
//       // ✅ Debug (uncomment once)
//       // print("PHOTON URL: $uri");
//       // print("STATUS: ${res.statusCode}");
//       // print("BODY: ${res.body}");
//
//       if (res.statusCode != 200) {
//         suggestions.clear();
//         return;
//       }
//
//       final json = jsonDecode(res.body) as Map<String, dynamic>;
//       final features = (json['features'] as List?) ?? [];
//
//       suggestions.value = features.map<Map<String, dynamic>>((f) {
//         final props = (f as Map<String, dynamic>)['properties'] as Map? ?? {};
//
//         final name = (props['name'] ?? '').toString();
//         final city = (props['city'] ?? props['state'] ?? '').toString();
//         final country = (props['country'] ?? '').toString();
//
//         final display = [name, city, country]
//             .where((e) => e.trim().isNotEmpty)
//             .join(', ');
//
//         return {'display_name': display};
//       }).where((m) => (m['display_name'] ?? '').toString().trim().isNotEmpty).toList();
//
//     } catch (e) {
//       // ✅ quick debug
//       // print("Search error: $e");
//       suggestions.clear();
//     } finally {
//       isSearching.value = false;
//     }
//   }
//
//   void clearSuggestions() => suggestions.clear();
//
//   /// ✅ When user taps a suggestion item
//   void selectSuggestion(Map<String, dynamic> item) {
//     final name = (item['display_name'] ?? '').toString().trim();
//     updateLocation(name);
//     suggestions.clear();
//   }
// }

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:uuid/uuid.dart';

import '../../../constants/app_constants.dart';
import '../../../helpers/notification_helper.dart';
import '../models/alarm_model.dart';
import 'dart:async';
Timer? _debounce;


class AlarmController extends GetxController {
  // ── Existing fields ───────────────────────────────────────────────
  var locationText = ''.obs;
  var suggestions = <Map<String, dynamic>>[].obs;
  var isSearching = false.obs;

  late Box _locationBox;



  @override
  Future<void> onInit() async {
    super.onInit();

    await _ensureHiveBoxes(); // alarms + location box open করবে

    // ✅ use the SAME location box
    _locationBox = Hive.box(AppConstants.hiveLocationBox);

    _loadLocation();  // args or hive থেকে load
    _loadAlarms();
  }

  // ── Save location ─────────────────────────────────────────────────
// ── Save location ─────────────────────────────────────────────────
  Future<void> updateLocation(String text) async {
    final v = text.trim();
    if (v.isEmpty) return;

    locationText.value = v;

    try {
      await _locationBox.put(AppConstants.locationKey, {
        'address': v,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      // debugPrint("✅ Saved: ${_locationBox.get(AppConstants.locationKey)}");
    } catch (e) {
      // debugPrint("❌ Save error: $e");
    }

    suggestions.clear();
  }

  void stopSearch() {
    _debounce?.cancel();
    isSearching.value = false;
  }

  Future<void> searchLocations(String query) async {
    final q = query.trim();
    _debounce?.cancel();

    if (q.length < 2) {
      suggestions.clear();
      isSearching.value = false;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 450), () async {
      isSearching.value = true;
      suggestions.clear();

      try {
        final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
          'name': q,
          'count': '8',
          'language': 'en',
          'format': 'json',
        });

        final res = await http
            .get(uri, headers: const {'Accept': 'application/json'})
            .timeout(const Duration(seconds: 20));

        // debug (1 time)
        debugPrint("OPENMETEO URL: $uri");
        debugPrint("OPENMETEO STATUS: ${res.statusCode}");
        debugPrint(res.body.substring(0, res.body.length > 120 ? 120 : res.body.length));

        if (res.statusCode != 200) {
          suggestions.clear();
          return;
        }

        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final results = (json['results'] as List?) ?? [];

        final temp = results.map<Map<String, dynamic>>((r) {
          final m = r as Map<String, dynamic>;
          final name = (m['name'] ?? '').toString();
          final admin1 = (m['admin1'] ?? '').toString();
          final country = (m['country'] ?? '').toString();

          final display = [name, admin1, country]
              .where((e) => e.trim().isNotEmpty)
              .join(', ');

          return {'display_name': display};
        }).toList();

        suggestions.value = temp;
      } catch (e) {
        suggestions.clear();
      } finally {
        isSearching.value = false;
      }
    });
  }

  void selectSuggestion(Map<String, dynamic> item) {
    final name = (item['display_name'] as String?)?.trim() ?? '';
    if (name.isNotEmpty) {
      updateLocation(name);
    }
    suggestions.clear();
  }

  void clearSuggestions() => suggestions.clear();

  // ... rest of your controller (alarms, toggle, delete, addAlarm, etc.)

  final RxList<AlarmModel> alarms = <AlarmModel>[].obs;

  /// Current selected location text shown on UI
  // final RxString locationText = ''.obs;

  /// Loading for adding alarm
  final RxBool isLoading = false.obs;

  /// Search state for location dialog suggestions
  //final suggestions = <Map<String, dynamic>>[].obs;
  //final isSearching = false.obs;

  late Box<AlarmModel> _alarmsBox;

  //late Box _locationBox;

  Future<void> _ensureHiveBoxes() async {
    // Alarms box (typed)
    if (!Hive.isBoxOpen(AppConstants.hiveAlarmsBox)) {
      _alarmsBox = await Hive.openBox<AlarmModel>(AppConstants.hiveAlarmsBox);
    } else {
      _alarmsBox = Hive.box<AlarmModel>(AppConstants.hiveAlarmsBox);
    }

    // Location box (dynamic)
    if (!Hive.isBoxOpen(AppConstants.hiveLocationBox)) {
      _locationBox = await Hive.openBox(AppConstants.hiveLocationBox);
    } else {
      _locationBox = Hive.box(AppConstants.hiveLocationBox);
    }
  }

  void _loadLocation() {
    // 1) read from route arguments (highest priority)
    final args = Get.arguments;
    if (args != null && args is Map) {
      final argLoc = args['location'];
      if (argLoc != null) {
        locationText.value = argLoc.toString().trim();
      }
    }

    // 2) if empty, read from Hive saved location
    if (locationText.value.isEmpty) {
      try {
        final saved = _locationBox.get(AppConstants.locationKey);
        if (saved is Map) {
          final address = saved['address'];
          if (address != null) {
            locationText.value = address.toString().trim();
          }
        } else if (saved is String) {
          // if you ever saved as plain string
          locationText.value = saved.trim();
        }
      } catch (_) {}
    }
  }

  void _loadAlarms() {
    try {
      alarms.assignAll(_alarmsBox.values.toList());
    } catch (_) {
      alarms.clear();
    }
  }

  // -------------------- Alarm CRUD --------------------

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

      final locationBody =
          (alarm.location != null && alarm.location!.isNotEmpty)
          ? 'Time to prepare! Location: ${alarm.location}'
          : 'Your travel alarm is ringing!';

      await NotificationHelper.scheduleAlarmNotification(
        id: alarm.id.hashCode.abs(),
        title: '⏰ Travel Alarm',
        body: locationBody,
        scheduledDate: alarm.dateTime,
        payload: alarm.id,
      );

      if (kDebugMode) {
        await NotificationHelper.debugPrintPending();
      }

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
      if (kDebugMode) {
        // ignore: avoid_print
        print('Alarm scheduling error: $e');
      }
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

      final notificationId = alarm.id.hashCode.abs();

      if (updatedAlarm.isEnabled) {
        final locationBody =
            (updatedAlarm.location != null && updatedAlarm.location!.isNotEmpty)
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
}

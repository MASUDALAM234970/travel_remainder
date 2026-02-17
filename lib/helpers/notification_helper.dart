import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationHelper {
  NotificationHelper._();

  static FlutterLocalNotificationsPlugin? _plugin;

  // Singleton-like access (optional but cleaner usage)
  static FlutterLocalNotificationsPlugin get plugin {
    if (_plugin == null) {
      throw Exception('NotificationHelper not initialized. Call initialize() first.');
    }
    return _plugin!;
  }

  static Future<void> initialize() async {
    _plugin = FlutterLocalNotificationsPlugin();

    tzdata.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // ← This is the fixed call
    await plugin.initialize(
      settings: initSettings,  // named parameter 'settings'
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request notification permission (Android 13+)
    final androidImpl = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    // Request exact alarm permission (Android 12+/14+)
    final bool? exactGranted = await androidImpl?.requestExactAlarmsPermission();
    if (exactGranted == false) {
      print('Exact alarm permission denied → alarms may delay or fail in Doze mode.');
    }
  }

  static void _onNotificationTapped(NotificationResponse details) {
    // Handle tap here (e.g., navigate using details.payload)
    print('Notification tapped: ${details.payload}');
    // Example: if (details.payload != null) { appRouter.push('/alarm/${details.payload}'); }
  }

  static Future<void> scheduleAlarmNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload, // Optional: e.g. json string for deep link
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // Ensure it's in the future
    if (tzDate.isBefore(now) || tzDate.isAtSameMomentAs(now)) {
      tzDate = tzDate.add(const Duration(days: 1)); // or handle error
      print('Scheduled time was in past → moved to next day: $tzDate');
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_channel',
        'Travel Alarms',
        channelDescription: 'Notifications for travel alarms',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
        fullScreenIntent: true, // Full-screen for alarms (heads-up + lock screen)
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;

    try {
      await plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: details,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
      print('Scheduled exact alarm: $id at $tzDate');
    } on Exception catch (e) {
      print('Exact schedule failed: $e');
      // Fallback to inexact (no permission crash, but may delay)
      await plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
      print('Fallback: Scheduled inexact alarm: $id at $tzDate');
    }
  }

  static Future<void> cancelNotification({
    required int id,
  }) async {
    await plugin.cancel(id: id);
    print('Cancelled notification: $id');
  }

  static Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
    print('All notifications cancelled');
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_channel',
        'Travel Alarms',
        channelDescription: 'Notifications for travel alarms',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // Helper: Check pending notifications (for debugging)
  static Future<void> debugPrintPending() async {
    final pending = await plugin.pendingNotificationRequests();
    print('Pending notifications: ${pending.length}');
    for (var p in pending) {
      print(' - ID: ${p.id}, Title: ${p.title ?? 'no title'}');
    }
  }
}
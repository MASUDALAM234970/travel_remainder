# ✈️ Travel Alarm App

A beautiful Flutter app for smart travel alarms with onboarding, location access, and scheduled notifications — built with **GetX** architecture.

---

## 📱 Screens

| Onboarding 1 | Onboarding 2 | Onboarding 3 | Location | Home |
|:---:|:---:|:---:|:---:|:---:|
| Discover the World | Explore Horizons | See the Beauty | Use Location | Set Alarms |

---

## 🏗️ Project Structure

```
lib/
├── common_widgets/
│   ├── location_field.dart        # Reusable location input field
│   ├── primary_button.dart        # Gradient CTA button
│   └── secondary_button.dart      # Outlined button
├── constants/
│   ├── app_colors.dart            # Color palette
│   ├── app_constants.dart         # Onboarding data & app constants
│   ├── app_routes.dart            # GetX named routes
│   └── app_text_styles.dart       # Typography system
├── features/
│   ├── onboarding/
│   │   ├── bindings/onboarding_binding.dart
│   │   ├── controllers/onboarding_controller.dart
│   │   └── views/
│   │       ├── onboarding_view.dart
│   │       └── widgets/
│   │           ├── onboarding_page_widget.dart   # Custom drawn scenes
│   │           └── page_indicator.dart
│   ├── location/
│   │   ├── bindings/location_binding.dart
│   │   ├── controllers/location_controller.dart
│   │   └── views/location_view.dart
│   └── alarm/
│       ├── bindings/alarm_binding.dart
│       ├── controllers/alarm_controller.dart
│       ├── models/
│       │   ├── alarm_model.dart                 # Hive model
│       │   └── alarm_model.g.dart               # Generated adapter
│       └── views/
│           ├── alarm_view.dart
│           └── widgets/
│               ├── alarm_tile.dart              # Swipe-to-delete tile
│               └── add_alarm_bottom_sheet.dart  # Date/time picker
├── helpers/
│   ├── location_helper.dart       # Geolocator + Geocoding
│   └── notification_helper.dart   # flutter_local_notifications
└── main.dart                      # App entry with Hive + TZ init
```

---


---



| Package | Purpose |

  # State Management
  get:

  # Location
  geolocator:
  geocoding:
  permission_handler:
  google_places_flutter:

  # Local Notifications
  flutter_local_notifications:
  timezone:

  # Local Storage
  hive:
  hive_flutter:

  # Unique IDs
  uuid:

  # UI Helpers

  intl:




##  Features

### Onboarding


### Location
- GPS permission request with `permission_handler`
- `geolocator` for real-time coordinates
- `geocoding` for human-readable address
- Saved to Hive for persistence

### Alarms (Home Screen)
- Displays saved location in a field
- Add alarms via FAB → bottom sheet:
  - Horizontal date carousel (14 days)
  - `CupertinoDatePicker` for time
- Alarm list with:
  - Formatted time (`7:10 pm`)
  - Formatted date (`Fri 21 Mar 2025`)
  - Toggle switch (animated, purple when active)
  - Swipe-to-delete
- Alarms persisted in Hive

### Notifications
- Exact alarm scheduling with `flutter_local_notifications`
- `timezone`-aware `zonedSchedule`
- Full-screen intent on Android
- Snackbar feedback on set/delete

### PERMISSION_MANIFEST

    <!-- Internet -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- Location -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

    <!-- Alarms & Notifications -->
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>


    
     <receiver
          android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
                android:exported="false"/>

        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
            </intent-filter>
        </receiver>

        <service
            android:name="com.dexterous.flutterlocalnotifications.ForegroundService"
            android:exported="false"
            android:stopWithTask="false"/>





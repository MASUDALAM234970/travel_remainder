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

## 🚀 Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run
```bash
flutter run
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `get ^4.6.6` | State management, routing, DI |
| `geolocator ^11.0.0` | GPS location |
| `geocoding ^3.0.0` | Reverse geocoding (coordinates → address) |
| `permission_handler ^11.3.0` | Runtime permissions |
| `flutter_local_notifications ^17.2.2` | Local alarm notifications |
| `timezone ^0.9.4` | Timezone-aware scheduling |
| `hive ^2.2.3` | Fast local database |
| `hive_flutter ^1.1.0` | Hive Flutter integration |
| `uuid ^4.4.0` | Unique alarm IDs |
| `intl ^0.19.0` | Date/time formatting |

---

## ✨ Features

### Onboarding
- 3 fullscreen pages with custom `CustomPainter` travel scenes:
  - **Screen 1**: Airplane wing through clouds ✈️
  - **Screen 2**: Sunset ocean waves 🌊
  - **Screen 3**: Sailboat on turquoise water ⛵
- Animated page indicator dots
- Skip button

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

---

## 🤖 Android Setup

Add to `android/app/build.gradle`:
```groovy
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

The `AndroidManifest.xml` includes all required permissions:
- `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`
- `POST_NOTIFICATIONS`
- `RECEIVE_BOOT_COMPLETED` (alarms survive reboot)

---

## 🍎 iOS Setup

`Info.plist` includes:
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysUsageDescription`
- `UIBackgroundModes: fetch, remote-notification`

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#5B2EFF` |
| Background | `#0A0B1E` |
| Surface | `#1A1B3A` |
| Text Primary | `#FFFFFF` |
| Text Secondary | `#B0B3CC` |

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'constants/app_routes.dart';
import 'features/alarm/models/alarm_model.dart';
import 'helpers/notification_helper.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter()); // assuming you have this
  await Hive.openBox<AlarmModel>(AppConstants.hiveAlarmsBox);
  await Hive.openBox(AppConstants.hiveLocationBox);

  // Initialize notifications **once** here

  await NotificationHelper.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Figma design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Travel Remainder ',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
            ),
            useMaterial3: true,
          ),

          initialRoute: AppRoutes.onboarding,
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}

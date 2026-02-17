import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/alarm_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/location_field.dart';
import 'widgets/alarm_tile.dart';
import 'widgets/add_alarm_bottom_sheet.dart';

class AlarmView extends GetView<AlarmController> {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Selected Location Title
                const Text(
                  'Selected Location',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 14),

                // Location Field
                Obx(() => LocationField(
                      locationText: controller.locationText.value,
                      onTap: () => _showLocationDialog(context),
                    )),
                const SizedBox(height: 32),

                // Alarms title
                const Text(
                  'Alarms',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 16),

                // Alarms list
                Expanded(
                  child: Obx(() {
                    if (controller.alarms.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.separated(
                      itemCount: controller.alarms.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final alarm =
                            controller.alarms[index];
                        return AlarmTile(
                          alarm: alarm,
                          onToggle: () =>
                              controller.toggleAlarm(alarm),
                          onDelete: () =>
                              controller.deleteAlarm(alarm),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),

      // FAB - Add Alarm
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddAlarmBottomSheet(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm_off_rounded,
            size: 64,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No alarms set',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add an alarm',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAlarmBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddAlarmBottomSheet(
        onAlarmAdded: (dateTime) {
          controller.addAlarm(dateTime);
        },
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    final textController =
        TextEditingController(text: controller.locationText.value);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Update Location',
          style: AppTextStyles.headlineMedium,
        ),
        content: TextField(
          controller: textController,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter location',
            hintStyle: AppTextStyles.bodyMedium,
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.location_on_outlined,
                color: AppColors.primary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.updateLocation(textController.text);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/alarm_controller.dart'; // ← adjust path if needed
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
                Text(
                  'Selected Location',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 14),
                Obx(() => LocationField(
                  locationText: controller.locationText.value,
                  onTap: () => _showLocationDialog(context),
                )),
                const SizedBox(height: 32),
                 Text(
                  'Alarms',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.alarms.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.separated(
                      itemCount: controller.alarms.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final alarm = controller.alarms[index];
                        return AlarmTile(
                          alarm: alarm,
                          onToggle: () => controller.toggleAlarm(alarm),
                          onDelete: () => controller.deleteAlarm(alarm),
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
    final textController = TextEditingController(text: controller.locationText.value);

    // Auto-focus the field when dialog opens
    FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (ctx) {
        // Auto-focus after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });

        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title:  Text('Update Location', style: AppTextStyles.headlineMedium),
          content: SizedBox(
            width: double.maxFinite,
            // Increase height a bit for better visibility of empty message
            height: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  focusNode: focusNode,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                   hintText:  'Enter location (e.g.  New York)',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                      height: 1.4,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  onChanged: controller.searchLocations,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.isSearching.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final query = textController.text.trim();

                    if (controller.suggestions.isEmpty) {
                      if (query.length >= 2) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No location found',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try different spelling\nor use your typed location.',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.edit_location_alt),
                                      label: Text('Use: "$query"'),
                                      onPressed: () {
                                        controller.stopSearch();
                                        Navigator.pop(ctx, query);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }




                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.08),
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.suggestions[index];
                          final title = item['display_name'] as String? ?? '';
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.place, color: AppColors.primary),
                            title: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                            ),
                            onTap: () {
                              controller.selectSuggestion(item);
                              textController.text = controller.locationText.value;
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 8, right: 12, left: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                final trimmed = textController.text.trim();
                if (trimmed.isNotEmpty) {
                  controller.updateLocation(trimmed);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    ).then((_) {
      textController.dispose();
      focusNode.dispose();
    });
  }
}
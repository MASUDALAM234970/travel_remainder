import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../common_widgets/primary_button.dart';

class AddAlarmBottomSheet extends StatefulWidget {
  final Function(DateTime) onAlarmAdded;

  const AddAlarmBottomSheet({
    super.key,
    required this.onAlarmAdded,
  });

  @override
  State<AddAlarmBottomSheet> createState() => _AddAlarmBottomSheetState();
}

class _AddAlarmBottomSheetState extends State<AddAlarmBottomSheet> {
  DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Set Alarm',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),

              // Preview
              Text(
                DateFormat('h:mm a · EEE, d MMM yyyy')
                    .format(selectedDateTime),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker row
              _buildDatePickerRow(),
              const SizedBox(height: 16),

              // Time Picker
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: selectedDateTime,
                    use24hFormat: false,
                    onDateTimeChanged: (dt) {
                      setState(() {
                        selectedDateTime = DateTime(
                          selectedDateTime.year,
                          selectedDateTime.month,
                          selectedDateTime.day,
                          dt.hour,
                          dt.minute,
                        );
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Set Alarm Button
              PrimaryButton(
                text: 'Set Alarm',
                onTap: () {
                  Navigator.pop(context);
                  widget.onAlarmAdded(selectedDateTime);
                },
                icon: Icons.alarm_add_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerRow() {
    final now = DateTime.now();
    final dates = List.generate(
        14, (i) => now.add(Duration(days: i)));

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.year == selectedDateTime.year &&
              date.month == selectedDateTime.month &&
              date.day == selectedDateTime.day;
          final isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  selectedDateTime.hour,
                  selectedDateTime.minute,
                );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(14),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppColors.primary.withOpacity(0.5),
                        width: 1,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

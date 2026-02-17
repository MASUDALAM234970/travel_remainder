import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../models/alarm_model.dart';

class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alarm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: alarm.isEnabled
                ? AppColors.cardGradient
                : [
                    AppColors.surface.withOpacity(0.6),
                    AppColors.surface.withOpacity(0.4),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: alarm.isEnabled
                ? AppColors.primary.withOpacity(0.2)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: alarm.isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Time and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTime(alarm.dateTime),
                    style: AppTextStyles.alarmTime.copyWith(
                      color: alarm.isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  if (alarm.location != null && alarm.location!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: AppColors.primary.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              alarm.location!,
                              style: AppTextStyles.alarmDate.copyWith(
                                fontSize: 11,
                                color: AppColors.primary.withOpacity(0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Date
            Text(
              _formatDate(alarm.dateTime),
              style: AppTextStyles.alarmDate.copyWith(
                color: alarm.isEnabled
                    ? AppColors.textSecondary
                    : AppColors.textHint,
              ),
            ),
            const SizedBox(width: 16),

            // Toggle switch
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 54,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: alarm.isEnabled
                      ? AppColors.toggleActive
                      : AppColors.toggleInactive,
                  boxShadow: alarm.isEnabled
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: alarm.isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime).toLowerCase();
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEE d MMM yyyy').format(dateTime);
  }
}

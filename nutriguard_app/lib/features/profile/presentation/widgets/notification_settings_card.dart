import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class NotificationSettingsCard extends StatefulWidget {
  const NotificationSettingsCard({super.key});

  @override
  State<NotificationSettingsCard> createState() =>
      _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  // Temporary UI settings
  bool _mealReminders = true;
  bool _healthReminders = true;
  bool _aiSuggestionAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primary,
                size: 26,
              ),
              SizedBox(width: 10),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Meal logging reminders
          _notificationSwitch(
            title: 'Meal Logging Reminders',
            value: _mealReminders,
            onChanged: (value) {
              setState(() {
                _mealReminders = value;
              });
            },
          ),

          const Divider(),

          // Monthly health marker reminder
          _notificationSwitch(
            title: 'Monthly Health Marker Reminder',
            value: _healthReminders,
            onChanged: (value) {
              setState(() {
                _healthReminders = value;
              });
            },
          ),

          const Divider(),

          // AI suggestion alerts
          _notificationSwitch(
            title: 'AI Suggestion Alerts',
            value: _aiSuggestionAlerts,
            onChanged: (value) {
              setState(() {
                _aiSuggestionAlerts = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _notificationSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),

        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/health_report_model.dart';

class HealthReportCard extends StatelessWidget {
  final HealthReportModel report;
  final VoidCallback onTap;

  const HealthReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  String get formattedDate {
    final day = report.reportDate.day.toString().padLeft(2, '0');
    final month = report.reportDate.month.toString().padLeft(2, '0');

    return '$day/$month/${report.reportDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EFF2)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE2F5EF),
          child: Icon(Icons.description_outlined, color: AppColors.primary),
        ),
        title: Text(
          report.reportName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$formattedDate · '
            '${report.measurements.length} measurements',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
      ),
    );
  }
}

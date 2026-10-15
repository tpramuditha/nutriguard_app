import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../widgets/health_marker_card.dart';
import '../../../../app/routes/route_names.dart';

class HealthProfilePage extends StatefulWidget {
  const HealthProfilePage({super.key});

  @override
  State<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  // Start with the current month.
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get _monthLabel {
    return '${_months[_selectedMonth.month - 1]} '
        '${_selectedMonth.year}';
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$feature will be added next.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        title: const Text(
          'Health Profile',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5FAFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showComingSoon('Health history'),
            icon: const Icon(Icons.history),
            label: const Text('History'),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly reminder
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFD6A1)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Color(0xFFFF8A00),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "No health markers recorded for this month yet.",
                      style: TextStyle(fontSize: 12, color: Color(0xFFAD5500)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.logHealthMarker);
                    },
                    child: const Text('Log Now'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Month selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                  color: AppColors.primary,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _monthLabel,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                  color: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Example health markers — not actual records
            HealthMarkerCard(
              title: 'Cholesterol',
              value: 'Not recorded',
              lastLogged: 'No measurements yet',
              icon: Icons.water_drop,
              iconColor: const Color(0xFFFF7043),
              onTap: () => _showComingSoon('Cholesterol details'),
            ),

            const SizedBox(height: 12),

            HealthMarkerCard(
              title: 'Blood Sugar',
              value: 'Not recorded',
              lastLogged: 'No measurements yet',
              icon: Icons.water_drop_outlined,
              iconColor: const Color(0xFF2389E8),
              onTap: () => _showComingSoon('Blood Sugar details'),
            ),

            const SizedBox(height: 12),

            HealthMarkerCard(
              title: 'Blood Pressure',
              value: 'Not recorded',
              lastLogged: 'No measurements yet',
              icon: Icons.favorite,
              iconColor: const Color(0xFFF04468),
              onTap: () => _showComingSoon('Blood Pressure details'),
            ),

            const SizedBox(height: 24),

            // Other Health Reports section
            const Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Other Health Reports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Empty state - no additional reports saved yet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE0EFF2)),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    color: AppColors.textSecondary,
                    size: 38,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No additional health reports yet',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add a laboratory report to track more '
                    'health measurements.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Add Health Report button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.addHealthReport);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Health Report'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.logHealthMarker);
              },
              icon: const Icon(Icons.add),
              label: const Text("Log This Month's Markers"),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.scanHealthReport);
              },
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text('Scan Blood Report (Auto-fill)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'AI will suggest values — you confirm before saving',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF4B83B6)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This is general wellness guidance, '
                      'not medical advice. Consult a doctor '
                      'for health decisions.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF4B83B6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

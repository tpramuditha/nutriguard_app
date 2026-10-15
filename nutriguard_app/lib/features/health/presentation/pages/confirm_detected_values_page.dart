import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../widgets/detected_measurement_card.dart';

class ConfirmDetectedValuesPage extends StatefulWidget {
  const ConfirmDetectedValuesPage({super.key});

  @override
  State<ConfirmDetectedValuesPage> createState() =>
      _ConfirmDetectedValuesPageState();
}

class _ConfirmDetectedValuesPageState extends State<ConfirmDetectedValuesPage> {
  final List<Map<String, dynamic>> _measurements = [
    {
      'title': 'Cholesterol',
      'value': '220',
      'unit': 'mg/dL',
      'icon': Icons.water_drop,
      'color': Colors.deepOrange,
      'lowConfidence': true,
      'confirmed': false,
    },
    {
      'title': 'Blood Sugar',
      'value': '95',
      'unit': 'mg/dL',
      'icon': Icons.water_drop_outlined,
      'color': Colors.blue,
      'lowConfidence': false,
      'confirmed': false,
    },
    {
      'title': 'Blood Pressure',
      'value': '120/80',
      'unit': 'mmHg',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'lowConfidence': false,
      'confirmed': false,
    },
  ];

  bool get _allConfirmed =>
      _measurements.every((measurement) => measurement['confirmed'] == true);

  void _updateValue(int index, String value) {
    setState(() {
      _measurements[index]['value'] = value;
      _measurements[index]['confirmed'] = false;
    });
  }

  void _confirmValue(int index) {
    final measurement = _measurements[index];

    final title = measurement['title'] as String;
    final value = (measurement['value'] as String).trim();

    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a value before confirming.')),
      );
      return;
    }

    if (title == 'Blood Pressure') {
      // Expected format: systolic/diastolic
      final parts = value.split('/');

      if (parts.length != 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enter blood pressure as systolic/diastolic, '
              'for example 120/80.',
            ),
          ),
        );
        return;
      }

      final systolic = int.tryParse(parts[0].trim());
      final diastolic = int.tryParse(parts[1].trim());

      if (systolic == null ||
          diastolic == null ||
          systolic <= 0 ||
          diastolic <= 0 ||
          systolic <= diastolic) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter valid systolic and diastolic values.'),
          ),
        );
        return;
      }
    } else {
      final number = double.tryParse(value);

      if (number == null || !number.isFinite || number <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter a valid positive number for $title.')),
        );
        return;
      }
    }

    setState(() {
      _measurements[index]['confirmed'] = true;
    });
  }

  void _showDemoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo only — Firestore saving will be added later.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      appBar: AppBar(
        title: const Text('Confirm Detected Values'),
        backgroundColor: const Color(0xFFF5FAFC),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F4FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.description_outlined, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demo scan results. Please review each '
                        'value before confirming.',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              for (int index = 0; index < _measurements.length; index++)
                DetectedMeasurementCard(
                  key: ValueKey(_measurements[index]['title']),
                  title: _measurements[index]['title'] as String,
                  value: _measurements[index]['value'] as String,
                  unit: _measurements[index]['unit'] as String,
                  icon: _measurements[index]['icon'] as IconData,
                  iconColor: _measurements[index]['color'] as Color,
                  lowConfidence: _measurements[index]['lowConfidence'] as bool,
                  isConfirmed: _measurements[index]['confirmed'] as bool,
                  onValueChanged: (value) {
                    _updateValue(index, value);
                  },
                  onConfirm: () {
                    _confirmValue(index);
                  },
                ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _allConfirmed
                      ? 'All values confirmed. '
                            'Saving is not yet implemented.'
                      : 'Confirm every value to enable the '
                            'demo Save button.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _allConfirmed ? _showDemoMessage : null,
                  child: const Text('Save Confirmed Values'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

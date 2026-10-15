import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class LogHealthMarkerPage extends StatefulWidget {
  const LogHealthMarkerPage({super.key});

  @override
  State<LogHealthMarkerPage> createState() => _LogHealthMarkerPageState();
}

class _LogHealthMarkerPageState extends State<LogHealthMarkerPage> {
  final _formKey = GlobalKey<FormState>();

  String _glucoseType = 'Fasting';

  final _totalCholesterolController = TextEditingController();
  final _ldlController = TextEditingController();
  final _hdlController = TextEditingController();
  final _triglyceridesController = TextEditingController();

  final _glucoseController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  @override
  void dispose() {
    _totalCholesterolController.dispose();
    _ldlController.dispose();
    _hdlController.dispose();
    _triglyceridesController.dispose();

    _glucoseController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();

    super.dispose();
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional measurement
    }

    final number = double.tryParse(value.trim());

    if (number == null || !number.isFinite || number <= 0) {
      return 'Enter a valid positive number';
    }

    return null;
  }

  void _saveMarkers() {
    final hasCholesterol =
        _totalCholesterolController.text.trim().isNotEmpty ||
        _ldlController.text.trim().isNotEmpty ||
        _hdlController.text.trim().isNotEmpty ||
        _triglyceridesController.text.trim().isNotEmpty;

    final hasGlucose = _glucoseController.text.trim().isNotEmpty;
    final hasSystolic = _systolicController.text.trim().isNotEmpty;
    final hasDiastolic = _diastolicController.text.trim().isNotEmpty;

    if (!hasCholesterol && !hasGlucose && !hasSystolic && !hasDiastolic) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one measurement.')),
      );
      return;
    }

    if (hasSystolic != hasDiastolic) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter both systolic and diastolic pressure.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // Firestore saving will be implemented later.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Measurements validated. Firebase saving comes next.'),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0EFF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _numberField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String unit,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: unit,
      ),
      validator: _validateNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF5FAFC),
        title: const Text(
          'Log Health Markers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lipid Profile - all four measurements
              _sectionCard(
                title: 'Lipid Profile (Cholesterol)',
                icon: Icons.water_drop,
                color: const Color(0xFFFF7043),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter the values available on your blood report.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _numberField(
                      label: 'Total Cholesterol',
                      hint: 'e.g. 200',
                      controller: _totalCholesterolController,
                      unit: 'mg/dL',
                    ),

                    const SizedBox(height: 14),

                    _numberField(
                      label: 'LDL Cholesterol',
                      hint: 'e.g. 120',
                      controller: _ldlController,
                      unit: 'mg/dL',
                    ),

                    const SizedBox(height: 14),

                    _numberField(
                      label: 'HDL Cholesterol',
                      hint: 'e.g. 50',
                      controller: _hdlController,
                      unit: 'mg/dL',
                    ),

                    const SizedBox(height: 14),

                    _numberField(
                      label: 'Triglycerides',
                      hint: 'e.g. 150',
                      controller: _triglyceridesController,
                      unit: 'mg/dL',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: 'Blood Sugar',
                icon: Icons.water_drop_outlined,
                color: const Color(0xFF2389E8),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _glucoseType,
                      decoration: const InputDecoration(
                        labelText: 'Measurement Context',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Fasting',
                          child: Text('Fasting'),
                        ),
                        DropdownMenuItem(
                          value: 'Random',
                          child: Text('Random'),
                        ),
                        DropdownMenuItem(
                          value: 'After Meal',
                          child: Text('After Meal'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _glucoseType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _numberField(
                      label: 'Blood Glucose',
                      hint: 'e.g. 95',
                      controller: _glucoseController,
                      unit: 'mg/dL',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: 'Blood Pressure',
                icon: Icons.favorite,
                color: const Color(0xFFF04468),
                child: Row(
                  children: [
                    Expanded(
                      child: _numberField(
                        label: 'Systolic',
                        hint: '120',
                        controller: _systolicController,
                        unit: '',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _numberField(
                        label: 'Diastolic',
                        hint: '80',
                        controller: _diastolicController,
                        unit: '',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Blood pressure is recorded in mmHg. '
                'Enter measurements as reported, without '
                'changing or estimating values.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 20),

              const Text(
                'Measurements are self-reported and are '
                'not automatically classified as normal '
                'or abnormal.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _saveMarkers,
                child: const Text("Save This Month's Markers"),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

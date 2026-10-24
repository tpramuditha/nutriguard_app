import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/routes/route_names.dart';
import 'food_search_page.dart';

class FoodScannerPage extends StatefulWidget {
  const FoodScannerPage({super.key});

  @override
  State<FoodScannerPage> createState() => _FoodScannerPageState();
}

class _FoodScannerPageState extends State<FoodScannerPage> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Barcode', 'Photo', 'Search', 'Manual'];

  void _selectTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isSelected = _selectedTab == index;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _selectTab(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFEAF5F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlaceholder({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0EFF2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 68, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeTab() {
    return Column(
      children: [
        _buildPlaceholder(
          icon: Icons.qr_code_scanner,
          title: 'Barcode Scanner',
          description: 'Camera barcode scanning will be implemented next.',
        ),
        const SizedBox(height: 14),
        const Text(
          'Align barcode within frame',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 22),
        CircleAvatar(
          radius: 34,
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectTab(1),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Take Photo', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectTab(3),
                icon: const Icon(Icons.edit_note),
                label: const Text(
                  'Type Manually',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildBarcodeTab();

      case 1:
        return _buildPlaceholder(
          icon: Icons.camera_alt_outlined,
          title: 'Scan Food Photo',
          description: 'Food photo recognition will be implemented later.',
        );

      case 2:
        return Column(
          children: [
            _buildPlaceholder(
              icon: Icons.search,
              title: 'Search Food',
              description: 'Search for food by name to view nutrition data.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FoodSearchPage()),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Open Food Search'),
            ),
          ],
        );

      case 3:
        return _buildPlaceholder(
          icon: Icons.edit_note,
          title: 'Manual Food Entry',
          description: 'Manual nutrition entry will be implemented later.',
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      appBar: AppBar(
        title: const Text(
          'Log Food',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5FAFC),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.foodHistory);
            },
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
            _buildTabs(),
            const SizedBox(height: 20),
            _buildTabContent(),
            const SizedBox(height: 28),
            const Text(
              'Recently Logged',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your recently logged foods will appear here.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

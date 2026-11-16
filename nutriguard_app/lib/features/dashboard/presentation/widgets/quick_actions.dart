import 'package:flutter/material.dart';

import '../../../../app/routes/route_names.dart';
import '../../../pantry/presentation/pages/pantry_page.dart';

class QuickActions extends StatelessWidget {
  final Future<void> Function()? onScanFood;

  const QuickActions({super.key, this.onScanFood});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _action(context, Icons.qr_code_scanner, 'Scan Food', () {
            if (onScanFood != null) {
              onScanFood!();
            } else {
              Navigator.pushNamed(context, RouteNames.foodScanner);
            }
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _action(context, Icons.kitchen, 'Pantry', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PantryPage()),
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _action(context, Icons.calendar_month, 'Planner', () {
            Navigator.pushNamed(context, RouteNames.planner);
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _action(context, Icons.favorite, 'Health', () {
            Navigator.pushNamed(context, RouteNames.health);
          }),
        ),
      ],
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}

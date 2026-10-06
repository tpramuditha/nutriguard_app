import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class NutriGuardApp extends StatelessWidget {
  const NutriGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriGuard',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const Scaffold(body: Center(child: Text('NutriGuard'))),
    );
  }
}

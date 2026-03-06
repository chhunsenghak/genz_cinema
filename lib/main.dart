import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/platform/sqlite_init.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initSqliteForPlatform();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const GenZCinemaApp(),
    ),
      );
}

class GenZCinemaApp extends StatelessWidget {
  const GenZCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'GenZ Cinema',
      theme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}

import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/platform/sqlite_init.dart';
import 'features/auth/presentation/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initSqliteForPlatform();

  runApp(const GenZCinemaApp());
}

class GenZCinemaApp extends StatelessWidget {
  const GenZCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GenZ Cinema',
      theme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}

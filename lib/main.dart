import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Window Manager Desktop
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(1024, 700),
    center: true,
    title: 'Shrimp Drive — Master Admin Panel',
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    const ProviderScope(
      child: ShrimpAdminApp(),
    ),
  );
}

class ShrimpAdminApp extends StatelessWidget {
  const ShrimpAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shrimp Drive Admin',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1218),
        primaryColor: const Color(0xFFFF6B4A),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Shrimp Drive Desktop Admin Ready!'),
        ),
      ),
    );
  }
}

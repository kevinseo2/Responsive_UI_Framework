import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Home Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // TV apps typically use dark theme
      ),
      home: const ResolutionSimulator(
        enabled: kDebugMode,
        showControls: true,
        showFullscreen: true,
        child: HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_ui_framework/framework/resolution_simulator.dart';
import 'package:responsive_ui_framework/framework/responsive_layout.dart';
import 'package:responsive_ui_framework/framework/screen_aspect_ratio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive UI Framework Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResolutionSimulator(
        enabled: kDebugMode, // 디버그 모드에서만 활성화
        child: MyHomePage(title: 'Responsive UI Framework Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ResponsiveLayout(
        child: const Center(child: Text('Default Layout')),
        layoutBuilders: {
          ScreenAspectRatio.ratio32x9: (context) => _buildUltraWideLayout(),
          ScreenAspectRatio.ratio16x9: (context) => _buildLandscapeLayout(),
          ScreenAspectRatio.ratio9x16: (context) => _buildPortraitLayout(),
        },
      ),
    );
  }

  Widget _buildUltraWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[100],
            child: const Center(child: Text('Left Panel')),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue[200],
            child: const Center(child: Text('Main Content')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[300],
            child: const Center(child: Text('Right Panel')),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue[200],
            child: const Center(child: Text('Main Content')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[300],
            child: const Center(child: Text('Side Panel')),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue[200],
            child: const Center(child: Text('Main Content')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[300],
            child: const Center(child: Text('Bottom Panel')),
          ),
        ),
      ],
    );
  }
}

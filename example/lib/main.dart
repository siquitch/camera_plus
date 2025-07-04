import 'package:camera_plus/camera_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExampleCamera(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExampleCamera extends StatefulWidget {
  const ExampleCamera({super.key});

  @override
  State<ExampleCamera> createState() => _ExampleCameraState();
}

class _ExampleCameraState extends State<ExampleCamera> {
  final cameraManager = CameraManager();

  @override
  void initState() {
    super.initState();
    cameraManager.init();
  }

  @override
  void dispose() {
    super.dispose();
    cameraManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      cameraManager: cameraManager,
      bottomBarBuilder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Expanded(
            child: CameraButton(
              onTap: () {},
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

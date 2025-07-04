import 'package:camra/model/camra_manager.dart';
import 'package:camra/ui/camra.dart';
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
      home: const Example(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final cameraManager = CamraManager();

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
    return Camra(
      cameraManager: cameraManager,
      bottomBarBuilder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Expanded(
            child: CamraButton(
              onTap: () {},
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

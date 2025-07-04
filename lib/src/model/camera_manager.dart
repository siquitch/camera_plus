import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import '../../camera_plus.dart';

typedef CameraListProvider = Future<List<CameraDescription>> Function();
typedef CameraControllerFactory =
    CameraController Function(CameraDescription camera);

class CameraManager {
  final ValueNotifier<CameraState> state = ValueNotifier(CameraState.initial());

  final CameraListProvider getAvailableCameras;
  final CameraControllerFactory createController;

  CameraManager()
    : getAvailableCameras = _defaultCameraListProvider,
      createController = _defaultControllerFactory;

  /// Constructor for testing only
  @visibleForTesting
  CameraManager.test({
    required this.getAvailableCameras,
    required this.createController,
  });

  static Future<List<CameraDescription>> _defaultCameraListProvider() =>
      availableCameras();

  static CameraController _defaultControllerFactory(CameraDescription camera) =>
      CameraController(camera, ResolutionPreset.medium);

  /// Initializes camera state
  Future<void> init() async {
    try {
      final cameras = await getAvailableCameras();
      final active = cameras.first;
      final controller = createController(active);
      await controller.initialize();

      state.value = state.value.copyWith(
        controller: controller,
        activeCamera: active,
        availableCameras: cameras,
        isInitialized: true,
      );
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
    }
  }

  /// Switches to the next available camera
  Future<void> switchCamera() async {
    final current = state.value.activeCamera;
    final cameras = state.value.availableCameras;
    final index = cameras.indexOf(current!);
    final next = cameras[(index + 1) % cameras.length];

    final controller = createController(next);
    await controller.initialize();
    await state.value.controller?.dispose();

    state.value = state.value.copyWith(
      controller: controller,
      activeCamera: next,
      isInitialized: true,
    );
  }

  /// Wraps [CameraController.takePicture]
  Future<XFile> takePicture() async {
    if (!state.value.isReady) {
      throw CameraManagerException('CameraManager not ready');
    }
    return await state.value.controller!.takePicture();
  }

  /// Disposes active controller
  Future<void> dispose() async {
    await state.value.controller?.dispose();
  }
}

class CameraManagerException implements Exception {
  CameraManagerException(this.message);

  final String message;

  @override
  String toString() => message;
}

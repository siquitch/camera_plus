import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final CameraDescription? activeCamera;
  final List<CameraDescription> availableCameras;
  final String? error;

  const CameraState({
    required this.isInitialized,
    required this.activeCamera,
    required this.availableCameras,
    this.controller,
    this.error,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    CameraDescription? activeCamera,
    List<CameraDescription>? availableCameras,
    String? error,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      activeCamera: activeCamera ?? this.activeCamera,
      availableCameras: availableCameras ?? this.availableCameras,
      error: error,
    );
  }

  factory CameraState.initial() => CameraState(
    controller: null,
    isInitialized: false,
    activeCamera: null,
    availableCameras: [],
  );
}

class CameraManager {
  final ValueNotifier<CameraState> state = ValueNotifier(CameraState.initial());

  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final active = cameras.first;
      final controller = CameraController(active, ResolutionPreset.medium);
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

  Future<void> switchCamera() async {
    final current = state.value.activeCamera;
    final cameras = state.value.availableCameras;
    final index = cameras.indexOf(current!);
    final next = cameras[(index + 1) % cameras.length];
    final controller = CameraController(next, ResolutionPreset.medium);
    await controller.initialize();

    await state.value.controller?.dispose();
    state.value = state.value.copyWith(
      controller: controller,
      activeCamera: next,
      isInitialized: true,
    );
  }

  Future<void> dispose() async {
    await state.value.controller?.dispose();
  }
}

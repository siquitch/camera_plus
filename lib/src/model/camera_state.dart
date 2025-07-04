import 'package:camera/camera.dart';

class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final CameraDescription? activeCamera;
  final List<CameraDescription> availableCameras;
  final String? error;

  const CameraState._({
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
    return CameraState._(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      activeCamera: activeCamera ?? this.activeCamera,
      availableCameras: availableCameras ?? this.availableCameras,
      error: error,
    );
  }

  factory CameraState.initial() => CameraState._(
    controller: null,
    isInitialized: false,
    activeCamera: null,
    availableCameras: [],
  );

  /// Whether the camera is ready to use
  bool get isReady => isInitialized && controller != null;
}

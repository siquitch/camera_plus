import 'package:camera/camera.dart';

class CamraState {
  final CameraController? controller;
  final bool isInitialized;
  final CameraDescription? activeCamera;
  final List<CameraDescription> availableCameras;
  final String? error;

  const CamraState._({
    required this.isInitialized,
    required this.activeCamera,
    required this.availableCameras,
    this.controller,
    this.error,
  });

  CamraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    CameraDescription? activeCamera,
    List<CameraDescription>? availableCameras,
    String? error,
  }) {
    return CamraState._(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      activeCamera: activeCamera ?? this.activeCamera,
      availableCameras: availableCameras ?? this.availableCameras,
      error: error,
    );
  }

  factory CamraState.initial() => CamraState._(
    controller: null,
    isInitialized: false,
    activeCamera: null,
    availableCameras: [],
  );

  /// Whether the camera is ready to use
  bool get isReady => isInitialized && controller != null;
}

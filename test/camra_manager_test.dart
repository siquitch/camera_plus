import 'package:camra/model/camra_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  late MockCameraController mockController;
  late MockCameraDescription camera1;
  late MockCameraDescription camera2;
  late CamraManager cameraManager;

  setUp(() {
    mockController = MockCameraController();
    camera1 = MockCameraDescription();
    camera2 = MockCameraDescription();

    cameraManager = CamraManager.test(
      getAvailableCameras: () async => [camera1, camera2],
      createController: (_) => mockController,
    );
  });

  test('init sets up the first camera correctly', () async {
    when(mockController.initialize()).thenAnswer((_) async {});
    when(camera1.name).thenReturn('0');
    when(camera2.name).thenReturn('1');

    cameraManager = CamraManager.test(
      getAvailableCameras: () async => [camera1, camera2],
      createController: (_) => mockController,
    );

    await cameraManager.init();

    final state = cameraManager.state.value;
    expect(state.availableCameras, containsAll([camera1, camera2]));
    expect(state.controller, equals(mockController));
    expect(state.activeCamera, equals(camera1));
    expect(state.isInitialized, isTrue);
  });
  test('switchCamera cycles to the next camera', () async {
    // Arrange
    final mockNextController = MockCameraController();

    cameraManager = CamraManager.test(
      getAvailableCameras: () async => [camera1, camera2],
      createController: (camera) {
        if (camera == camera1) return mockController;
        return mockNextController;
      },
    );

    when(mockController.initialize()).thenAnswer((_) async {});
    when(mockNextController.initialize()).thenAnswer((_) async {});
    when(mockController.dispose()).thenAnswer((_) async {});

    await cameraManager.init(); // init with camera1

    // Act
    await cameraManager.switchCamera(); // switch to camera2

    // Assert
    final state = cameraManager.state.value;
    expect(state.activeCamera, equals(camera2));
    expect(state.controller, equals(mockNextController));
    expect(state.isInitialized, isTrue);
  });
}

import 'package:camra/model/camra_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks.mocks.dart';

void main() {
  group('CameraState', () {
    test('initial state has expected defaults', () {
      final state = CamraState.initial();

      expect(state.controller, isNull);
      expect(state.isInitialized, isFalse);
      expect(state.activeCamera, isNull);
      expect(state.availableCameras, isEmpty);
      expect(state.error, isNull);
      expect(state.isReady, isFalse);
    });

    test('copyWith overrides specified values only', () {
      final mockController = MockCameraController();
      final mockCamera = MockCameraDescription();
      final initialState = CamraState.initial();

      final updated = initialState.copyWith(
        controller: mockController,
        isInitialized: true,
        activeCamera: mockCamera,
        availableCameras: [mockCamera],
        error: 'Camera error',
      );

      expect(updated.controller, equals(mockController));
      expect(updated.isInitialized, isTrue);
      expect(updated.activeCamera, equals(mockCamera));
      expect(updated.availableCameras, contains(mockCamera));
      expect(updated.error, 'Camera error');
    });

    test(
      'isReady returns true only when initialized and controller is set',
      () {
        final mockController = MockCameraController();
        final state = CamraState.initial();

        expect(state.isReady, isFalse);

        final notReady1 = state.copyWith(isInitialized: true);
        final notReady2 = state.copyWith(controller: mockController);

        expect(notReady1.isReady, isFalse);
        expect(notReady2.isReady, isFalse);

        final ready = state.copyWith(
          isInitialized: true,
          controller: mockController,
        );

        expect(ready.isReady, isTrue);
      },
    );
  });
}

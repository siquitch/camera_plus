A simple, camera wrapper built on top of [`camera`](https://pub.dev/packages/camera)
Designed for convienient camera setup and control on Android and iOS

---

## Features

- Simple `CameraManager` for camera setup and control
- Support for switching cameras
- Picture capture
- Fully testable via injectable dependencies
- Optional customizable preview widget

---

![Preview](https://github.com/siquitch/camera_plus/example/preview.png)

## Getting Started

### 1. Add dependency

```yaml
dependencies:
  camera_plus: ^0.1.0
```

### 2. Platform setup

#### Follow camera setup instructions for:

##### Android

Add required permissions to android/app/src/main/AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

##### iOS

Add usage descriptions to ios/Runner/Info.plist:

```plist
<key>NSCameraUsageDescription</key>
<string>We need access to the camera to take photos.</string>
```

### Usage
Initialize the manager

``` dart
final manager = CameraManager();

await manager.init(); // must be called before use
```

### Display a preview

#### Build your own widget using the included state, or use the [`CameraView`](https://github.com/siquitch/camera_plus) widget (see [example](https://pub.dev/packages/camera_plus/example)):

```dart
ValueListenableBuilder<CameraState>(
  valueListenable: manager.state,
  builder: (context, state, _) {
    if (state.error != null) {
      return Text('Camera error: ${state.error}');
    }

    if (!state.isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: state.controller!.value.aspectRatio,
      child: CameraPreview(state.controller!),
    );
  },
)
```

#### Switch camera

```dart
await manager.switchCamera();
```

#### Capture image

``` dart
final file = await manager.takePicture();
print('Saved at ${file.path}');
```

### Roadmap

* Zoom, flash, focus, and exposure controls
* Video recording

### License

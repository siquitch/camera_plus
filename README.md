# 📷 camera_plus

[![Pub Version](https://img.shields.io/pub/v/camera_plus?color=blue)](https://pub.dev/packages/camera_plus)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-green)
[![License](https://img.shields.io/github/license/siquitch/camera_plus)](https://github.com/siquitch/camera_plus/blob/master/LICENSE)
[![Stars](https://img.shields.io/github/stars/siquitch/camera_plus?style=social)](https://github.com/siquitch/camera_plus/stargazers)

> A simple camera wrapper built on top of [`camera`](https://pub.dev/packages/camera).  
> Designed for straightforward camera setup and control on Android and iOS.

---

## ✨ Features

- ✅ `CameraManager` for setup and camera control
- 🔁 Camera switching (front/back)
- 📸 Picture capture support
- 🧪 Fully testable with injectable dependencies
- 🎨 Optional customizable preview widget

---

## 🖼️ Preview

![Preview](https://github.com/siquitch/camera_plus/raw/master/example/preview.png)

---

## ⚙️ Getting Started

### 1️⃣ Add dependency

```yaml
dependencies:
  camera_plus: ^0.1.0
```
# 📷 Camera Integration Guide

## 2️⃣ Platform Setup

### 📱 Android

Add the required permission in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### 🍏 iOS

Add the camera usage description in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to the camera to take photos.</string>
```

---

## 💡 Usage

### 🔧 Initialize the Camera

```dart
final manager = CameraManager();
await manager.init(); // Must be called before usage
```

---

### 🖼️ Display a Camera Preview

Use the built-in state with your own widget or the prebuilt `CameraView`.

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
      aspectRatio: 1 / state.controller!.value.aspectRatio,
      child: CameraPreview(state.controller!),
    );
  },
)
```

---

### 🔁 Switch Camera

```dart
await manager.switchCamera();
```

---

### 📸 Capture Image

```dart
final file = await manager.takePicture();
print('Saved at ${file.path}');
```

---

## 🛣️ Roadmap

- 🔍 Zoom control  
- ⚡ Flash toggle  
- 🎥 Video recording  
- 🎯 Manual focus & exposure  

---

## 📄 License

This project is licensed under the **MIT License**.

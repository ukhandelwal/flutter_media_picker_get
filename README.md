# Flutter Media Picker Getx

A Flutter package that provides a customizable and easy-to-use media picker, allowing users to select multiple images or videos with support for camera integration.

## Features

- **Multi-media selection**: Choose between Images, Videos, or both.
- **Dynamic Sorting**: Media is automatically sorted by creation date (newest first).
- **Instant Refresh**: Photos captured via the internal camera appear instantly in the gallery.
- **Customizable UI**: Set a custom title for the picker's AppBar.
- **Single or Multiple Selection**: Supports both single-item picking and multi-select modes.
- **Camera Integration**: Capture new photos directly within the picker.
- **Pagination support**: Smoothly handles large galleries using efficient pagination.

## Installation

Add the following dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_media_picker_getx: ^1.0.0
```

## Android Permissions
Ensure you have the following permissions in your `AndroidManifest.xml`:

```xml
<uses-feature
    android:name="android.hardware.camera"
    android:required="false" />

<uses-permission
    android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29"
    tools:replace="android:maxSdkVersion" />
<uses-permission android:name="android.permission.INTERNET" />
    
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />

<application
    android:requestLegacyExternalStorage="true"
    android:usesCleartextTraffic="true">
</application>
```

## iOS Permissions

Open `Info.plist` and add the following keys for camera and photo library access:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to allow you to capture photos and videos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to allow you to select photos and videos.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save photos and videos to your photo library.</string>
```

## Usage

### 1. Import the package
```dart
import 'package:flutter_media_picker_getx/flutter_media_picker_getx.dart';
```

### 2. Launch the MediaPicker
```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPicker(
          title: "Select Media",      // Optional custom title
          mediaCount: 10,             // Max items to select
          selection: SelectionEnum.MultiMedia, // Image/Video/Multi
          multiSelection: true,       // Allow multiple
          cameraEnable: true,         // Enable camera capture
          onPressedConfirm: myCallback,
        ),
      ),
    );
  },
  child: Text("Open Picker"),
);
```

### 3. Handle the Callback
```dart
Future<void> myCallback({required dynamic value}) async {
  if (value is List<MediaItem>) {
    for (var media in value) {
      final file = await media.assetEntity.file;
      print("Selected file (${media.type}): ${file?.path}");
    }
  } else if (value is MediaItem) {
    final file = await value.assetEntity.file;
    print("Selected file (${value.type}): ${file?.path}");
  }
}
```

## Parameters

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `title` | `String?` | Optional custom title for the AppBar. |
| `mediaCount` | `int` | Maximum number of items allowed for selection (Default: 10). |
| `selection` | `SelectionEnum` | Filter media type: `Images`, `Videos`, or `MultiMedia`. |
| `multiSelection` | `bool` | Enables multi-select mode (Default: false). |
| `cameraEnable` | `bool` | Shows camera icon to capture new media (Default: false). |
| `onPressedConfirm` | `Function` | Callback returning the selected `MediaItem` or `List<MediaItem>`. |

## Example Project

Check the `example` folder for a complete implementation demonstrating single and multi-select flows.

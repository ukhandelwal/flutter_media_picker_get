# Flutter Media Picker Get

A Flutter package that provides a customizable and easy-to-use media picker, allowing users to select multiple images or videos with support for camera integration.

## Features

- Multi-media selection (Images and Videos)
- Single or multiple selection support
- Camera integration
- Customizable media count limit

## Installation

Add the following dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_media_picker_get: ^0.0.6
```
## Android Permissions
```yaml
<uses-feature
    android:name="android.hardware.camera"
    android:required="false" />

<uses-permission
    android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29"
    tools:replace="android:maxSdkVersion" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission
    android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29" />
    
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />

<application
android:name="${applicationName}"
android:icon="@mipmap/ic_launcher"
android:enableOnBackInvokedCallback="true"
android:label="example"
android:requestLegacyExternalStorage="true"
android:usesCleartextTraffic="true">
/>
```
## iOS Permissions

- Open Info.plist in your Flutter project, located at ios/Runner/Info.plist.
- Add the following keys for camera and photo library access. These keys provide descriptions that explain to users why your app requires these permissions:
```yaml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to allow you to capture photos and videos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to allow you to select photos and videos.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save photos and videos to your photo library.</string>
```

## Usage

To use the media picker, follow these steps:
- Import the package
```yaml
  import 'package:flutter_media_picker_get/flutter_media_picker_get.dart';
```
- Use the MediaPicker widget to open the media picker
```yaml
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPicker(
          mediaCount: 10,
          selection: SelectionEnum.MultiMedia,
          multiSelection: true,
          cameraEnable: true,
          onPressedConfirm: myCallback,
        ),
      ),
    );
  },
  child: Text("Picker"),
);
```

## Parameters

- mediaCount: Maximum number of items that can be selected.
- selection: Selection type. Use SelectionEnum.MultiMedia for images and videos.
- multiSelection: Boolean to allow multiple media selection.
- cameraEnable: Boolean to enable camera access within the picker.
- onPressedConfirm: Callback function triggered when the user confirms selection.

## Example
```yaml
import 'package:flutter/material.dart';
import 'package:flutter_media_picker_get/flutter_media_picker_get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<void> myCallback({required dynamic value}) async {
    if (value is List<MediaItem>) {
      for (var media in value) {
        if (media.type == MediaType.image) {
          final file = await media.assetEntity.file;
          if (file != null) {
            if (kDebugMode) {
              print("file $file");
            }
          }
        }
      }
    } else {
      if (value is MediaItem) {
        final file = await value.assetEntity.file;
        if (kDebugMode) {
          print("file $file");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Media Picker Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaPicker(
                  mediaCount: 10,
                  selection: SelectionEnum.MultiMedia,
                  multiSelection: true,
                  cameraEnable: true,
                  onPressedConfirm: myCallback,
                ),
              ),
            );
          },
          child: Text("Open Media Picker"),
        ),
      ),
    );
  }
}
```

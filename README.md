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
  flutter_media_picker_get: ^1.0.0
```

## Usage

To use the media picker, follow these steps:
- Import the package
```yaml
  import 'package:flutter_media_picker_get/flutter_media_picker_get.dart';
```
- Use the InstagramPicker widget to open the media picker
```yaml
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramPicker(
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

##Parameters

- mediaCount: Maximum number of items that can be selected.
- selection: Selection type. Use SelectionEnum.MultiMedia for images and videos.
- multiSelection: Boolean to allow multiple media selection.
- cameraEnable: Boolean to enable camera access within the picker.
- onPressedConfirm: Callback function triggered when the user confirms selection.

##Example
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
  void myCallback(List<String> selectedMedia) {
    // Handle selected media files here
    print("Selected Media: $selectedMedia");
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
                builder: (context) => InstagramPicker(
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

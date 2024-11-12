import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker_getx/flutter_media_picker_getx.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Picker',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                            )),
                  );
                },
                child: const Text("Picker"))
          ],
        ),
      ),
    );
  }

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
}

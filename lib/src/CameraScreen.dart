import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'controller/CameraControllerX.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraControllerX controller =
        Get.put(CameraControllerX(), permanent: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Camera with Zoom')),
      body: Obx(
        () => controller.initializeControllerFuture.value == null
            ? const CircularProgressIndicator()
            : FutureBuilder<void>(
                future: controller.initializeControllerFuture.value,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Obx(() {
                      return Stack(
                        children: [
                          CameraPreview(controller.cameraController),
                          if (controller.imageFile.value != null)
                            Positioned.fill(
                              child: PhotoView(
                                imageProvider: FileImage(
                                    File(controller.imageFile.value!.path)),
                              ),
                            ),
                        ],
                      );
                    });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.captureImage();
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

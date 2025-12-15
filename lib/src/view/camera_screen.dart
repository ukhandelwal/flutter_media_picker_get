import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker_getx/src/controller/media_controller.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/camera_controllerX.dart';
import '../utils/CustomOrientationBuilder.dart';

class CameraScreenNew extends StatefulWidget {
  const CameraScreenNew({super.key});

  @override
  State<CameraScreenNew> createState() => _CameraScreenNewState();
}

class _CameraScreenNewState extends State<CameraScreenNew> {
  final CameraControllerX controller =
      Get.put(CameraControllerX(), permanent: false);

  @override
  void dispose() {
    controller.cameraController.dispose();
    controller.dispose();
    if (Get.isRegistered<CameraControllerX>()) {
      Get.delete<CameraControllerX>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value == false &&
            controller.cameraController.value.isInitialized
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: CameraPreview(controller.cameraController),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomOrientationBuilder(
                    isVideosRecording: false,
                    builder: (context, orientation) {
                      return FloatingActionButton(
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          controller.captureImage(context);
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.flip_camera_android),
                      onPressed: () {
                        controller.switchCamera();
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator());
  }
}

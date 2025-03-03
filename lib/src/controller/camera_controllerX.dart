import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'media_controller.dart';

class CameraControllerX extends GetxController {
  late CameraController _cameraController;

  CameraController get cameraController => _cameraController;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    cameras.value = await availableCameras();
    final firstCamera = cameras.first;
    initialize(firstCamera);
    super.onInit();
  }

  Future<void> initialize(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);
    _cameraController.initialize().then((onValue) {
      isLoading(false);
      update();
    });
  }

  Future<void> captureImage(BuildContext context) async {
    await _cameraController.takePicture().then((value) async {
      bool permission = await requestPermission();
      if (permission) {
        await GallerySaver.saveImage(value.path);
        if (Get.isRegistered<MediaController>()) {
          Get.find<MediaController>().refreshData();
        }
        Navigator.pop(context, value.path);
      }
    });
  }

  @override
  void onClose() {
    _cameraController.dispose();
    super.onClose();
  }

  void switchCamera() {
    _cameraController.setDescription(
        cameras[_cameraController.description.name == "0" ? 1 : 0]);
  }

  Future<bool> requestPermission() async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

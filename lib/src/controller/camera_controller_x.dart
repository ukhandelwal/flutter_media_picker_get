import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'media_controller.dart';

/// Controller for managing camera initialization and capture logic.
class CameraControllerX extends GetxController {
  late CameraController _cameraController;

  CameraController get cameraController => _cameraController;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    bool permission = await requestCameraPermission();
    if(permission){
      cameras.value = await availableCameras();
      final firstCamera = cameras.first;
      initialize(firstCamera);
    }
  }

  Future<void> initialize(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    _cameraController.initialize().then((onValue) async {
      isLoading(false);
      update();
    });
  }

  Future<void> captureImage(BuildContext context) async {
    try {
      final XFile file = await _cameraController.takePicture();
      bool permission = await requestPermission();
      if (permission) {
        await GallerySaver.saveImage(file.path);
        
        // Give the OS a moment to index the new file in the MediaStore
        await Future.delayed(const Duration(milliseconds: 1000));
        
        if (Get.isRegistered<MediaController>()) {
          final mediaController = Get.find<MediaController>();
          // Clear photo_manager cache to ensure it sees the new file
          await PhotoManager.clearFileCache();
          await mediaController.fetchMedia(refresh: true);
        }
        
        if (context.mounted) {
          Navigator.pop(context, file.path);
        }
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
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

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CameraControllerX extends GetxController {
  late CameraController _cameraController;
  Rx<Future<void>?> initializeControllerFuture = Rx<Future<void>?>(null);
  var imageFile = Rxn<XFile>();

  @override
  Future<void> onInit() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    initialize(firstCamera);
    super.onInit();
  }

  Future<void> initialize(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.high);
    initializeControllerFuture.value = _cameraController.initialize();
  }

  CameraController get cameraController => _cameraController;

  Future<void> captureImage() async {
    if (!_cameraController.value.isInitialized) return;
    try {
      final image = await _cameraController.takePicture();
      imageFile.value = image;
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing image: $e');
      }
    }
  }

  @override
  void onClose() {
    _cameraController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../model/MediaItem.dart';

class InstaController extends GetxController {
  Rx<ScrollController> scrollController = ScrollController().obs;
  RxString mediaType = "images".obs;
  RxList<MediaItem> mediaList = <MediaItem>[].obs;
  RxList<MediaItem> allData = <MediaItem>[].obs;
  RxBool isLoading = false.obs;
  int currentPage = 0;
  bool hasMore = true;
  RxBool multiSelect = false.obs;
  final int pageSize = 2000;
  RxList<MediaItem> selectedMediaArray = <MediaItem>[].obs;
  Rxn<MediaItem> selectedMedia = Rxn<MediaItem>();
  VideoPlayerController? videoController;

  @override
  void onInit() {
    scrollController.value.addListener(_onScroll);
    requestPermissions();
    super.onInit();
  }

  Future<void> requestPermissions() async {
    PermissionStatus readStorageStatus = await Permission.storage.request();
    if (readStorageStatus.isGranted) {
      await fetchMedia();
    } else {
      Get.snackbar("Permission Denied", "Permission to access storage denied.");
    }
    PermissionStatus cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      Get.snackbar("Permission Denied", "Permission to use camera denied.");
    }
  }

  Future<void> fetchMedia({bool loadMore = false}) async {
    if (isLoading.value || !hasMore) return;
    isLoading.value = true;
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.all,
      hasAll: true,
    );
    if (albums.isNotEmpty) {
      final newMedia = await albums[0].getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );
      if (newMedia.isNotEmpty) {
        final List<MediaItem> items =
            await Future.wait(newMedia.map((media) async {
          final thumbnail =
              await media.thumbnailDataWithSize(const ThumbnailSize(200, 200));
          return MediaItem(
              id: media.id,
              type: media.type == AssetType.video
                  ? MediaType.video
                  : MediaType.image,
              thumbnail: thumbnail,
              isSelected: false,
              assetEntity: media);
        }));
        allData.addAll(items);
        filterData();
        currentPage++;
      } else {
        hasMore = false;
      }
    }
    isLoading.value = false;
  }

  void selectMedia(MediaItem media) {
    if (media.isSelected) {
      media.isSelected = false;
      selectedMediaArray.remove(media);
      if (media.type == MediaType.video) {
        _disposeVideoController();
      }
    } else {
      if (selectedMediaArray.length >= 10) return;
      selectedMedia.value = media;
      if (multiSelect.value) {
        media.isSelected = true;
        selectedMediaArray.add(media);
      }
      if (media.type == MediaType.video && selectedMediaArray.length < 2) {
        _playVideo(media.assetEntity);
      } else {
        _disposeVideoController();
      }
    }
    mediaList.refresh();
    selectedMediaArray.refresh();
    selectedMedia.refresh();
    // update();
  }

  Future<void> _playVideo(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null) {
      videoController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          videoController!.play();
          update();
        });
    }
  }

  void _onScroll() {
    if (scrollController.value.position.pixels ==
            scrollController.value.position.maxScrollExtent &&
        !isLoading.value) {
      fetchMedia(loadMore: true);
    }
  }

  void _disposeVideoController() {
    videoController?.dispose();
    videoController = null;
  }

  @override
  void dispose() {
    _disposeVideoController();
    scrollController.value.dispose();
    super.dispose();
  }

  void filterData() {
    if (mediaType.value == 'images') {
      mediaList.value =
          allData.where((item) => item.type == MediaType.image).toList();
    } else if (mediaType.value == 'videos') {
      mediaList.value =
          allData.where((item) => item.type == MediaType.video).toList();
    } else {
      mediaList.value = allData;
    }
  }

  void updateMultiSelect() {
    if (multiSelect.value) {
      multiSelect.value = false;
      selectedMediaArray.clear();
      for (var e in mediaList) {
        e.isSelected = false;
      }
    } else {
      multiSelect.value = true;
    }
  }
}
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker_getx/src/view/camera_screen.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../flutter_media_picker_getx.dart';
import '../controller/media_controller.dart';

class MediaPicker extends StatefulWidget {
  final int mediaCount;
  final bool cameraEnable;
  final bool multiSelection;
  final SelectionEnum selection;
  final void Function({required dynamic value}) onPressedConfirm;

  const MediaPicker(
      {super.key,
      this.mediaCount = 10,
      this.cameraEnable = false,
      this.multiSelection = false,
      this.selection = SelectionEnum.Images,
      required this.onPressedConfirm});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  final MediaController controller =
      Get.put(MediaController(), permanent: false);

  @override
  void dispose() {
    controller.dispose();
    controller.videoController?.dispose();
    controller.scrollController.value.dispose();();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('${widget.selection.name} Picker'), actions: [
        Obx(
          () => Visibility(
            visible: controller.multiSelect.value,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${controller.selectedMediaArray.length}/${widget.mediaCount}',
                  style: const TextStyle(fontSize: 16),
                )),
          ),
        ),
      ]),
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Obx(() {
                final selectedMedia =
                    controller.selectedMedia.value?.assetEntity;
                if (selectedMedia == null) {
                  return const Center(
                      child: Text(
                    'Select media to preview',
                    style: TextStyle(color: Colors.white),
                  ));
                } else if (selectedMedia.type == AssetType.video) {
                  final videoController = controller.videoController;
                  if (videoController != null &&
                      videoController.value.isInitialized) {
                    return AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  return FutureBuilder<Uint8List?>(
                    future: selectedMedia
                        .thumbnailDataWithSize(const ThumbnailSize(400, 400)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(snapshot.data!);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.selection == SelectionEnum.MultiMedia,
                    child: Obx(
                      () => DropdownButton<String>(
                        value: controller.mediaType.value,
                        dropdownColor: Colors.black,
                        underline: Container(),
                        style: const TextStyle(color: Colors.white),
                        items: <String>['images', 'videos'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toLowerCase(),
                            child: Text(
                              value[0].toUpperCase() + value.substring(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white),
                            ), // Display as "Image" or "Video"
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.mediaType.value = newValue;
                            controller.resetPagination();
                            controller.filterData();
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.selection != SelectionEnum.MultiMedia,
                    child: Text(
                      widget.selection.name[0].toUpperCase() +
                          widget.selection.name.substring(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: widget.multiSelection,
                    child: InkWell(
                      onTap: () {
                        controller.updateMultiSelect();
                      },
                      child: const Icon(
                        Icons.select_all,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.cameraEnable,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreenNew(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.selectedMedia.value != null,
                      child: GestureDetector(
                        onTap: () {
                          if (controller.selectedMediaArray.isNotEmpty) {
                            widget.onPressedConfirm(
                                value: controller.selectedMediaArray);
                          } else {
                            widget.onPressedConfirm(
                                value: controller.selectedMedia.value);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.mediaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return RawScrollbar(
                      thumbVisibility: true,
                      thumbColor: Colors.red,
                      controller: controller.scrollController.value,
                      child: GridView.builder(
                        controller: controller.scrollController.value,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: controller.mediaList.length,
                        itemBuilder: (context, index) {
                          final media = controller.mediaList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.selectMedia(media);
                            },
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.memory(media.thumbnail!,
                                      fit: BoxFit.cover),
                                ),
                                if (media.type == MediaType.video)
                                  const Positioned(
                                    top: 6,
                                    left: 8,
                                    child: Icon(Icons.video_call,
                                        color: Colors.white),
                                  ),
                                Obx(() => controller.multiSelect.value
                                    ? Positioned(
                                        top: 6,
                                        right: 8,
                                        child: Icon(
                                          media.isSelected
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Offstage())
                              ],
                            ),
                          );
                        },
                      ));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

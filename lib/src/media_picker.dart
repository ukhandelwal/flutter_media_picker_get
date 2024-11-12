import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker_getx/src/camera_screen.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import 'selection_enum.dart';
import 'controller/MediaController.dart';
import 'model/MediaItem.dart';

class MediaPicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final MediaController instaController =
        Get.put(MediaController(), permanent: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('${selection.name} Picker'), actions: [
        Obx(
          () => Visibility(
            visible: instaController.multiSelect.value,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${instaController.selectedMediaArray.length}/$mediaCount',
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
                    instaController.selectedMedia.value?.assetEntity;
                if (selectedMedia == null) {
                  return const Center(
                      child: Text(
                    'Select media to preview',
                    style: TextStyle(color: Colors.white),
                  ));
                } else if (selectedMedia.type == AssetType.video) {
                  final videoController = instaController.videoController;
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
                    visible: selection == SelectionEnum.MultiMedia,
                    child: Obx(
                      () => DropdownButton<String>(
                        value: instaController.mediaType.value,
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
                            instaController.mediaType.value = newValue;
                            instaController.filterData();
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selection != SelectionEnum.MultiMedia,
                    child: Text(
                      selection.name[0].toUpperCase() +
                          selection.name.substring(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: multiSelection,
                    child: InkWell(
                      onTap: () {
                        instaController.updateMultiSelect();
                      },
                      child: const Icon(
                        Icons.select_all,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: cameraEnable,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
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
                      visible: instaController.selectedMedia.value != null,
                      child: GestureDetector(
                        onTap: () {
                          if (instaController.selectedMediaArray.isNotEmpty) {
                            onPressedConfirm(
                                value: instaController.selectedMediaArray);
                          } else {
                            onPressedConfirm(
                                value: instaController.selectedMedia.value);
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
                if (instaController.isLoading.value &&
                    instaController.mediaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return RawScrollbar(
                      thumbVisibility: true,
                      thumbColor: Colors.red,
                      controller: instaController.scrollController.value,
                      child: GridView.builder(
                        controller: instaController.scrollController.value,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: instaController.mediaList.length,
                        itemBuilder: (context, index) {
                          final media = instaController.mediaList[index];
                          return GestureDetector(
                            onTap: () {
                              instaController.selectMedia(media);
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
                                Obx(() => instaController.multiSelect.value
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

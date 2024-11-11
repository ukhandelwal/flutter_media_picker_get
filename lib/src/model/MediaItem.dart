import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

enum MediaType { image, video }

class MediaItem {
  String id;
  MediaType type;
  bool isSelected;
  Uint8List? thumbnail;
  AssetEntity assetEntity;

  MediaItem({
    required this.id,
    required this.type,
    required this.isSelected,
    this.thumbnail,
    required this.assetEntity,
  });
}

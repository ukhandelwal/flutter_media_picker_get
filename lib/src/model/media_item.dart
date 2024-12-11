import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

enum MediaType { image, video }

class MediaItem {
  final String id;
  final MediaType type;
  bool isSelected;
  Uint8List? thumbnail;
  final AssetEntity assetEntity;

  MediaItem({
    required this.id,
    required this.type,
    this.isSelected = false,
    this.thumbnail,
    required this.assetEntity,
  });

  // Fetches the thumbnail if it hasn't been loaded
  Future<void> loadThumbnail({int size = 200}) async {
    if (thumbnail == null) {
      thumbnail =
          await assetEntity.thumbnailDataWithSize(ThumbnailSize(size, size));
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

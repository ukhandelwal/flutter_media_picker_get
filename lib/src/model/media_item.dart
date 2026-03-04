import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

/// The type of media item, either an image or a video.
enum MediaType { image, video }

/// A model representing a selectable media item in the picker.
class MediaItem {
  /// Unique identifier for the media item.
  final String id;
  
  /// The type of media (image or video).
  final MediaType type;
  
  /// Whether the item is currently selected.
  bool isSelected;
  
  /// The bytes of the thumbnail image for this media item.
  Uint8List? thumbnail;
  
  /// The underlying [AssetEntity] from the photo_manager package.
  final AssetEntity assetEntity;

  /// Creates a new [MediaItem] instance.
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

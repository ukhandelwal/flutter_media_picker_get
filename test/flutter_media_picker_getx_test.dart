import 'dart:typed_data';
import 'package:flutter_media_picker_getx/src/model/MediaItem.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_manager/photo_manager.dart';

// Mock class for AssetEntity
class MockAssetEntity extends Mock implements AssetEntity {}

void main() {
  group('MediaItem', () {
    late MockAssetEntity mockAssetEntity;
    late MediaItem mediaItem;

    setUp(() {
      mockAssetEntity = MockAssetEntity();
      mediaItem = MediaItem(
        id: 'test_id',
        type: MediaType.image,
        isSelected: false,
        assetEntity: mockAssetEntity,
      );
    });

    test('should initialize MediaItem with correct properties', () {
      expect(mediaItem.id, 'test_id');
      expect(mediaItem.type, MediaType.image);
      expect(mediaItem.isSelected, isFalse);
      expect(mediaItem.thumbnail, isNull);
    });

    test('loadThumbnail should fetch thumbnail data if not loaded', () async {
      // Mock the thumbnail data
      Uint8List mockThumbnailData = Uint8List(10);
      when(mockAssetEntity.thumbnailDataWithSize(const ThumbnailSize(200, 200)))
          .thenAnswer((_) async => mockThumbnailData);

      // Call loadThumbnail and verify
      await mediaItem.loadThumbnail(size: 200);
      expect(mediaItem.thumbnail, mockThumbnailData);

      // Ensure method is called once
      verify(mockAssetEntity.thumbnailDataWithSize(ThumbnailSize(200, 200)))
          .called(1);
    });

    test('loadThumbnail should not fetch thumbnail data if already loaded',
        () async {
      // Set thumbnail data manually
      mediaItem.thumbnail = Uint8List(10);

      // Call loadThumbnail and verify it does not fetch new data
      await mediaItem.loadThumbnail(size: 200);
      verifyNever(
          mockAssetEntity.thumbnailDataWithSize(const ThumbnailSize(200, 200)));
    });

    test('MediaItem equality based on id and type', () {
      final mediaItem1 = MediaItem(
        id: 'test_id_1',
        type: MediaType.image,
        isSelected: false,
        assetEntity: mockAssetEntity,
      );

      final mediaItem2 = MediaItem(
        id: 'test_id_1',
        type: MediaType.image,
        isSelected: true, // Different selection status should not matter
        assetEntity: mockAssetEntity,
      );

      final mediaItem3 = MediaItem(
        id: 'test_id_2',
        type: MediaType.video,
        isSelected: false,
        assetEntity: mockAssetEntity,
      );

      // Equality check
      expect(mediaItem1 == mediaItem2, isTrue);
      expect(mediaItem1 == mediaItem3, isFalse);
    });

    test('hashCode should be consistent with equality', () {
      final mediaItem1 = MediaItem(
        id: 'test_id',
        type: MediaType.image,
        isSelected: false,
        assetEntity: mockAssetEntity,
      );

      final mediaItem2 = MediaItem(
        id: 'test_id',
        type: MediaType.image,
        isSelected: true,
        assetEntity: mockAssetEntity,
      );

      expect(mediaItem1.hashCode, mediaItem2.hashCode);
    });
  });
}

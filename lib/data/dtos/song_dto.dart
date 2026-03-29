import '../../model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String artistIdKey = 'artistId';
  static const String durationKey = 'duration';
  static const String imageKey = 'imageUrl';
  static const String likeKey = 'likes';

  static Song fromJson(String id,Map<String, dynamic> json) {
    // assert(json[idKey] is String);
    assert(json[titleKey] is String);
    assert(json[artistIdKey] is String);
    assert(json[durationKey] is int);
    assert(json[imageKey] is String);
    assert(json[likeKey] == null || json[likeKey] is int);

    return Song(
      id: id,
      title: json[titleKey],
      artistId: json[artistIdKey],
      duration: Duration(milliseconds: json[durationKey]),
      image: Uri.parse(json[imageKey]), 
      likes: json[likeKey] ?? 0,
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageKey: song.image.toString(),
      likeKey: song.likes
    };
  }
}

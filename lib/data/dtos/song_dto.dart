import '../../model/songs/song.dart';

class SongDto {
  // static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String artistIdKey = 'artistId';
  static const String durationKey = 'duration';
  static const String imageKey = 'imageUrl';

  static Song fromJson(Map<String, dynamic> json) {
    // assert(json[idKey] is String);
    assert(json[titleKey] is String);
    assert(json[artistIdKey] is String);
    assert(json[durationKey] is int);

    return Song(
      // id: json[idKey],
      title: json[titleKey],
      artistId: json[artistIdKey],
      duration: Duration(milliseconds: json[durationKey]),
      image: Uri.parse(json[imageKey]),
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      // idKey: song.id,
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
    };
  }
}

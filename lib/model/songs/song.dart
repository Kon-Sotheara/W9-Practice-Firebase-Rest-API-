class Song {
  // final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri image;

  Song({
    // required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.image
  });

  @override
  String toString() {
    return 'Song(title: $title, artist: $artistId, duration: $duration)';
  }
}

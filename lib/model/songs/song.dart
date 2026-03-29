class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri image;
  int likes;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.image,
    required this.likes
  });

  @override
  String toString() {
    return 'Song(title: $title, artist: $artistId, duration: $duration)';
  }
}

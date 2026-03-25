class Artist {
  final String id;
  final String name;
  final String genre;
  final Uri image;

  Artist({
    required this.id,
    required this.name,
    required this.genre,
    required this.image,
  });

  @override
  String toString() {
    return 'Artist(name: $name, genre: $genre, image: $image)';
  }
}

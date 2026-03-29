class Comment {
  final String id;
  final String artistId;
  final String message;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.artistId,
    required this.message,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Comment(id: $id, artistId: $artistId, message: $message, createdAt: $createdAt)';
  }
}

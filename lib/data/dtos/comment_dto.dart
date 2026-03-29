import 'package:week09_firebase/model/comments/comment.dart';

class CommentDto {
  static const String artistIdKey = 'artistId';
  static const String messageKey = 'message';
  static const String createdAtKey = 'createdAt';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[artistIdKey] is String);
    assert(json[messageKey] is String);
    assert(json[createdAtKey] is String);

    return Comment(
      id: id,
      artistId: json[artistIdKey] as String,
      message: json[messageKey] as String,
      createdAt: DateTime.parse(json[createdAtKey] as String),
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistIdKey: comment.artistId,
      messageKey: comment.message,
      createdAtKey: comment.createdAt.toIso8601String(),
    };
  }
}

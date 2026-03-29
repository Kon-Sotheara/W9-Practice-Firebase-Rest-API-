import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week09_firebase/data/config/firebase_config.dart';
import 'package:week09_firebase/data/dtos/artist_dto.dart';
import 'package:week09_firebase/data/dtos/comment_dto.dart';
import 'package:week09_firebase/data/dtos/song_dto.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/model/comments/comment.dart';
import 'package:week09_firebase/model/songs/song.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  final Uri artistUri = FirebaseConfig.baseUir.replace(path: '/artists.json');
  final Uri songsUri = FirebaseConfig.baseUir.replace(path: '/songs.json');
  List<Artist>? _cachedArtist;
  final Map<String, List<Song>> _artistSongsCache = {};
  final Map<String, List<Comment>> _artistCommentsCache = {};

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtist != null) {
      return _cachedArtist!;
    }

    final http.Response response = await http.get(artistUri);
    List<Artist> result = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);
      for (var literable in artistJson.entries) {
        result.add(ArtistDto.fromJson(literable.key, literable.value));
      }

      _cachedArtist = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<List<Song>> fetchArtistSongs(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _artistSongsCache.containsKey(artistId)) {
      return _artistSongsCache[artistId]!;
    }

    final http.Response response = await http.get(songsUri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load artist songs');
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded == null) {
      _artistSongsCache[artistId] = [];
      return [];
    }

    final Map<String, dynamic> songJson = decoded as Map<String, dynamic>;
    final List<Song> songs = songJson.entries
        .map((entry) => SongDto.fromJson(entry.key, entry.value))
        .where((song) => song.artistId == artistId)
        .toList();

    _artistSongsCache[artistId] = songs;
    return songs;
  }

  @override
  Future<List<Comment>> fetchArtistComments(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _artistCommentsCache.containsKey(artistId)) {
      return _artistCommentsCache[artistId]!;
    }

    final Uri commentsUri = FirebaseConfig.baseUir.replace(
      path: '/comments/$artistId.json',
    );
    final http.Response response = await http.get(commentsUri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load artist comments');
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded == null) {
      _artistCommentsCache[artistId] = [];
      return [];
    }

    final Map<String, dynamic> commentJson = decoded as Map<String, dynamic>;
    final List<Comment> comments = commentJson.entries
        .map((entry) => CommentDto.fromJson(entry.key, entry.value))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _artistCommentsCache[artistId] = comments;
    return comments;
  }

  @override
  Future<Comment> postArtistComment(String artistId, String message) async {
    final Uri commentsUri = FirebaseConfig.baseUir.replace(
      path: '/comments/$artistId.json',
    );
    final Comment comment = Comment(
      id: '',
      artistId: artistId,
      message: message,
      createdAt: DateTime.now(),
    );

    final http.Response response = await http.post(
      commentsUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CommentDto.toJson(comment)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post artist comment');
    }

    final Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    final Comment savedComment = Comment(
      id: responseJson['name'] as String,
      artistId: comment.artistId,
      message: comment.message,
      createdAt: comment.createdAt,
    );

    final List<Comment> cachedComments = [
      savedComment,
      ...?_artistCommentsCache[artistId],
    ];
    _artistCommentsCache[artistId] = cachedComments;

    return savedComment;
  }
}

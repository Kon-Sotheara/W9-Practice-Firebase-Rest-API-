import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/model/comments/comment.dart';
import 'package:week09_firebase/model/songs/song.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<List<Song>> fetchArtistSongs(
    String artistId, {
    bool forceFetch = false,
  });

  Future<List<Comment>> fetchArtistComments(
    String artistId, {
    bool forceFetch = false,
  });

  Future<Comment> postArtistComment(String artistId, String message);
}

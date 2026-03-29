import 'package:flutter/material.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/model/comments/comment.dart';
import 'package:week09_firebase/model/songs/song.dart';
import 'package:week09_firebase/ui/utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<void> screenState = AsyncValue.loading();
  List<Song> songs = [];
  List<Comment> comments = [];
  bool isSubmittingComment = false;

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    fetchData();
  }

  Future<void> fetchData({bool forceFetch = false}) async {
    screenState = AsyncValue.loading();
    notifyListeners();

    try {
      final results = await Future.wait([
        artistRepository.fetchArtistSongs(artist.id, forceFetch: forceFetch),
        artistRepository.fetchArtistComments(artist.id, forceFetch: forceFetch),
      ]);

      songs = results[0] as List<Song>;
      comments = results[1] as List<Comment>;
      screenState = AsyncValue.success(null);
    } catch (e) {
      screenState = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<bool> addComment(String message) async {
    final String trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty || isSubmittingComment) {
      return false;
    }

    isSubmittingComment = true;
    notifyListeners();

    try {
      final Comment savedComment = await artistRepository.postArtistComment(
        artist.id,
        trimmedMessage,
      );
      comments = [savedComment, ...comments];
      return true;
    } catch (e) {
      screenState = AsyncValue.error(e);
      return false;
    } finally {
      isSubmittingComment = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;
  Map<String, Artist> artistMap = {};

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.artistRepository,
    required this.playerState,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Song> songs = await songRepository.fetchSongs(forceFetch: forceFetch);
      List<Artist> artists = await artistRepository.fetchArtists();

      for (var artist in artists) {
        artistMap[artist.id] = artist;
      }
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void likeSong (Song song) {
    try {
      songRepository.likeSong(song.id, song.likes);
      song.likes++;
      notifyListeners();
    } catch (e){
       print('Error liking song: $e');
    }
  }

  Artist getArtistName(String id) => artistMap[id]!;

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}

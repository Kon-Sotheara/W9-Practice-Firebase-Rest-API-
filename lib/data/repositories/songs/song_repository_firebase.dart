import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week09_firebase/data/config/firebase_config.dart';

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = FirebaseConfig.baseUir.replace(path: '/songs.json');
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);
    List<Song> result = [];

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      // return songJson.map((item) => SongDto.fromJson(item)).toList();
      for (var literable in songJson.entries) {
        result.add(SongDto.fromJson(literable.key, literable.value));
      }

      _cachedSongs = result;

      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return null; // we gonna update later
  }

  @override
  Future<void> likeSong(String songId, int currentLike) async {
    final Uri songsUri = FirebaseConfig.baseUir.replace(
      path: '/songs/$songId.json',
    );

    final updatedLike = currentLike + 1;

    final http.Response response = await http.patch(
      songsUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'likes': updatedLike}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update like');
    }
  }
}

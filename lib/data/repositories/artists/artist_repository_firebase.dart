import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week09_firebase/data/dtos/artist_dto.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/model/artists/artist.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  final Uri artistUri = Uri.https(
    'week09-firebase-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistUri);
    List<Artist> result = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);
      for (var literable in artistJson.entries) {
        result.add(ArtistDto.fromJson(literable.value));
      }
      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

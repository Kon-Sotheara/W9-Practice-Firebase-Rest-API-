import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/ui/screens/artist/view_model/artist_detail_view_model.dart';
import 'package:week09_firebase/ui/screens/artist/widgets/artist_detail_content.dart';

class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        artist: artist,
      ),
      child: ArtistDetailContent(artist: artist),
    );
  }
}

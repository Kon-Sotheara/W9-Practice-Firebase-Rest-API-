import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week09_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week09_firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:week09_firebase/ui/screens/artist/widgets/artist_content.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ArtistViewModel(artistRepository: context.read<ArtistRepository>()),
      child: ArtistContent(),
    );
  }
}

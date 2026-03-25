import 'package:flutter/material.dart';
import 'package:week09_firebase/model/artists/artist.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile({
    super.key, 
    required this.artist, 
    required this.onTap
  });

  final Artist artist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(artist.image.toString()),
          ),
          onTap: onTap,
          title: Text(artist.name),
          subtitle: Text(artist.genre),
        ),
      ),
    );
  }
}

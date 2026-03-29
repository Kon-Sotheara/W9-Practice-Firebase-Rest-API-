import 'package:flutter/material.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/ui/utils/duration_format.dart';

import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.artist,
    required this.onLike
  });

  final Artist artist;
  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onLike;

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
            backgroundImage: NetworkImage(song.image.toString()),
          ),
          onTap: onTap,
          title: Text(song.title),
          subtitle: Text(
            "${DurationFormat(song.duration)} ~ ${artist.name} - ${artist.genre}  :  Likes ${song.likes}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPlaying ? "Playing" : "",
                style: TextStyle(color: Colors.amber),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: onLike,
              )
            ],
          ),
        ),
      ),
    );
  }
}

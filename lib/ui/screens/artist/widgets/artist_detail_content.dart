import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week09_firebase/model/artists/artist.dart';
import 'package:week09_firebase/model/songs/song.dart';
import 'package:week09_firebase/ui/screens/artist/view_model/artist_detail_view_model.dart';
import 'package:week09_firebase/ui/screens/artist/widgets/comment_tile.dart';
import 'package:week09_firebase/ui/utils/async_value.dart';
import 'package:week09_firebase/ui/widgets/song/song_tile.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key, required this.artist});

  final Artist artist;

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ArtistDetailViewModel vm = context.read<ArtistDetailViewModel>();
    final bool isSuccess = await vm.addComment(_commentController.text);
    if (!mounted) {
      return;
    }

    if (isSuccess) {
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment posted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ArtistDetailViewModel vm = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.artist.name)),
      body: switch (vm.screenState.state) {
        AsyncValueState.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncValueState.error => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error: ${vm.screenState.error}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        AsyncValueState.success => RefreshIndicator(
          onRefresh: () => vm.fetchData(forceFetch: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              _ArtistHeader(artist: widget.artist),
              const SizedBox(height: 24),
              const Text(
                'Songs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _SongsSection(artist: widget.artist, songs: vm.songs),
              const SizedBox(height: 24),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _CommentsSection(),
            ],
          ),
        ),
      },
      bottomSheet: Material(
        elevation: 12,
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment about this artist',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Comment cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: vm.isSubmittingComment
                        ? null
                        : () => _submitComment(context),
                    child: vm.isSubmittingComment
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtistHeader extends StatelessWidget {
  const _ArtistHeader({required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(artist.image.toString()),
        ),
        const SizedBox(height: 12),
        Text(
          artist.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          artist.genre,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

class _SongsSection extends StatelessWidget {
  const _SongsSection({required this.artist, required this.songs});

  final Artist artist;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No songs available for this artist yet.'),
      );
    }

    return Column(
      children: songs
          .map(
            (song) => SongTile(
              artist: artist,
              song: song,
              isPlaying: false,
              onTap: () {},
              onLike: () {},
            ),
          )
          .toList(),
    );
  }
}

class _CommentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ArtistDetailViewModel vm = context.watch<ArtistDetailViewModel>();

    if (vm.comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No comments yet. Be the first to post one.'),
      );
    }

    return Column(
      children: vm.comments
          .map((comment) => CommentTile(comment: comment))
          .toList(),
    );
  }
}

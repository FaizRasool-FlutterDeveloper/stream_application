import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatefulWidget {
  final String videoKey;
  const TrailerPage({super.key, required this.videoKey});

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.yellow,
        topActions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: player,
          ),
        );
      },
    );
  }
}

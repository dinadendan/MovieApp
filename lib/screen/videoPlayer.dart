import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  const VideoPlayerScreen({Key ?key, required this.controller})
      : super(key: key);
  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState(controller);
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final YoutubePlayerController controller;

  VideoPlayerScreenState(this.controller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body:
        Stack(
          children: <Widget>[
            Center(
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
              ),
            ),
            Positioned(
              top: 40.0,
              right: 20.0,
              child: IconButton(icon: const Icon(EvaIcons.closeCircle, color: Colors.white, size: 30.0,), onPressed: () {
                Navigator.pop(context);
              }),
            )
          ],
        )
    );
  }
}
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPaly extends StatefulWidget {
  final String videoUrl;
  const VideoPaly({super.key, required this.videoUrl});

  @override
  State<VideoPaly> createState() => _VideoPalyState();
}

class _VideoPalyState extends State<VideoPaly> {
// Inside your chat message widget
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController!.value.isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  VideoPlayer(
                    _videoPlayerController!,
                  ),
                  Center(
                    child: IconButton(
                      icon: Icon(
                        _videoPlayerController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () {
                        _videoPlayerController!.value.isPlaying
                            ? _videoPlayerController!.pause()
                            : _videoPlayerController!.play();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}

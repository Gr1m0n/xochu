import 'package:flutter/material.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class Video extends StatefulWidget {
  final String? video;
  const Video({Key? key, required this.video})
      : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}
class _VideoState extends State<Video> {
  late YoutubePlayerController _controller;
  void initState() {
    var videoId = YoutubePlayer.convertUrlToId("${widget.video.toString()}");
    _controller = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBarWidget(title: 'Награждение'),
      ),
      body:YoutubePlayerBuilder(
          player: YoutubePlayer(
              controller: _controller,
          ),
          builder: (context, player) {
            return Column(
              children: [
                player,
              ],
            );
          }
      )
    );
  }
}
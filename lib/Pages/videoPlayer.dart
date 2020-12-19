import 'package:flutter/material.dart';
import 'package:the_movie/DatabaseModel/movieTrailer.dart';
import 'package:the_movie/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class VideoPlayer extends StatefulWidget {
  var videoId;
  VideoPlayer({Key key, @required this.videoId});
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  List<MovieTrailer> trailerList = List();

  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: 'NiZeMNPNrDw',
  //   flags: YoutubePlayerFlags(
  //     autoPlay: true,
  //     mute: true,
  //   ),
  // );

  YoutubePlayerController _controller(id) {
    return YoutubePlayerController(
        initialVideoId: id,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ));
  }

  getVideo() async {
    try {
      var response = await http.get("https://api.themoviedb.org/3/movie/" +
          widget.videoId.toString() +
          "/videos?api_key=9f78512afbf17738d97c7b1a40e32b43");
      var jsonResponse = convert.jsonDecode(response.body);
      //print(data['results']);
      for (var d in jsonResponse['results']) {
        trailerList.add(MovieTrailer.fromJson(d));
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideo();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: trailerList.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: YoutubePlayer(
            controller: _controller(trailerList[index].key.toString()),
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            progressIndicatorColor: AppColor().primaryColor,
          ),
        );
      },
    );
  }
}

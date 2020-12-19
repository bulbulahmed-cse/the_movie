import 'package:flutter/material.dart';
import 'package:the_movie/DatabaseModel/popularMovies.dart';
import 'package:the_movie/Pages/videoPlayer.dart';
import 'package:the_movie/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


// ignore: must_be_immutable
class MovieDetails extends StatefulWidget {
  PopularMovies movieDetail;
  MovieDetails({Key key,@required this.movieDetail});
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  var domain = "https://image.tmdb.org/t/p/w500";




  SizedBox _sizedBox = SizedBox(height: 10,);

  Widget detailText(text){
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryColor,
        title: Text(widget.movieDetail.title),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 300,
            color: AppColor().secondaryColor,

            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 10,
                    child: ClipRRect(child: Image.network(domain+widget.movieDetail.posterPath),
                      borderRadius: BorderRadius.circular(5),),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.movieDetail.title,style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 20),),
                        _sizedBox,
                        FittedBox(
                          fit: BoxFit.contain,
                          child: RatingBarIndicator(
                            rating: double.parse(widget.movieDetail.voteAverage.toString()),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 10,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                        detailText("Release Date: "+ widget.movieDetail.releaseDate.toString()),
                        detailText("Language : "+ widget.movieDetail.originalLanguage.toString())
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Overview",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 20),),
            )
          ),
          Card(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.movieDetail.overview),
          )),

          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trailers",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 20),),
                  _sizedBox,
                  VideoPlayer(videoId: widget.movieDetail.id,),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_movie/Animation/BouncyPageRoute.dart';
import 'package:the_movie/DatabaseModel/popularMovies.dart';
import 'package:the_movie/Pages/movieDetails.dart';
import 'package:the_movie/colors.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  List<PopularMovies> popularMovieList = List();
  var domain = "https://image.tmdb.org/t/p/w500";

  getData() async {
    try {
      var response = await http.get(
          "https://api.themoviedb.org/3/movie/popular?api_key=9f78512afbf17738d97c7b1a40e32b43");
      var jsonResponse = convert.jsonDecode(response.body);
      //print(data['results']);
      for (var d in jsonResponse['results']) {
        popularMovieList.add(PopularMovies.fromJson(d));
      }

      print(popularMovieList[0].posterPath);
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
    //print(popularMovieList[0].id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("The Movies"),
        backgroundColor: AppColor().primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SvgPicture.network(
            "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_1-5bdc75aaebeb75dc7ae79426ddd9be3b2be1e342510f8202baf6bffa71d7f5c4.svg",
            color: AppColor().secondaryColor,
            semanticsLabel: 'Logo',
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: GridView.builder(
                padding: EdgeInsets.only(left: 5, right: 5),
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .60,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: popularMovieList.length,
                itemBuilder: (_, index) {
                  var popularMovie = popularMovieList[index];
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        BouncyPageRoute(
                            widget: MovieDetails(
                              movieDetail: popularMovie,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn,
                            alignment: Alignment.centerRight)),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: ClipRRect(
                                child: popularMovie.posterPath == null
                                    ? Image.asset(
                                        "assets/images/not-found.jpg",
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        domain + popularMovie.posterPath,
                                        fit: BoxFit.fill,
                                      ),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(5)),
                              ),
                              flex: 7),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Align(
                                    child: Text(
                                      popularMovie.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    child: Text(
                                      "Rating: " +
                                          popularMovie.voteAverage.toString(),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:netflix/bloc/getMovieByGenre.dart';
import 'package:netflix/style/theme.dart' as Style;
import '../model/movie.dart';
import '../model/movieResponse.dart';
import '../screen/MovieDetials.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  const GenreMovies({Key ?key, required this.genreId}) : super(key: key);
  @override
  GenreMoviesState createState() => GenreMoviesState(genreId);
}

class GenreMoviesState extends State<GenreMovies> {
  final int genreId;
  GenreMoviesState(this.genreId);
  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error!);
          }
          return _buildHomeWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error as String);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occurred: $error"),
          ],
        ));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 270.0,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movie: movies[index]),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    movies[index].poster == null
                        ? Container(
                      width: 120.0,
                      height: 180.0,
                      decoration:  const BoxDecoration(
                        color: Style.Colors.secondColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            EvaIcons.filmOutline,
                            color: Colors.white,
                            size: 60.0,
                          )
                        ],
                      ),
                    )
                        : Container(
                        width: 120.0,
                        height: 180.0,
                        decoration:  BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                          shape: BoxShape.rectangle,
                          image:  DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200/${movies[index].poster}")),
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: const TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          movies[index].rating.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        RatingBar(
                          itemSize: 8.0,
                          ratingWidget: RatingWidget(
                            empty: const Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                            full: const Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                            half: const Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                          ),
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                          onRatingUpdate: (rating) {
                            debugPrint(rating as String);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
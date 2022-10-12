import 'package:flutter/material.dart';
import 'package:netflix/bloc/getMovieDetials.dart';
import 'package:netflix/model/movieDetailsResponse.dart';
import 'package:netflix/style/theme.dart' as Style;

import '../model/movieDetails.dart';

class MovieInfo extends StatefulWidget {
  final int id;
  const MovieInfo({Key ?key, required this.id}) : super(key: key);
  @override
  MovieInfoState createState() => MovieInfoState(id);
}

class MovieInfoState extends State<MovieInfo> {
  final int id;
  MovieInfoState(this.id);
  @override
  void initState() {
    super.initState();
    movieDetailBloc.getMovieDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildMovieDetailWidget(snapshot.data!);
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
          children: const [],
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

  Widget _buildMovieDetailWidget(MovieDetailResponse data) {
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "BUDGET",
                    style: TextStyle(
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${detail.budget}\$",
                    style: const TextStyle(
                        color: Style.Colors.secondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "DURATION",
                    style: TextStyle(
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text("${detail.runtime}min",
                      style: const TextStyle(
                          color: Style.Colors.secondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "RELEASE DATE",
                    style: TextStyle(
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(detail.releaseDate,
                      style: const TextStyle(
                          color: Style.Colors.secondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0))
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "GENRES",
                style: TextStyle(
                    color: Style.Colors.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 38.0,
                padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.genres!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                            border:
                            Border.all(width: 1.0, color: Colors.white)),
                        child: Text(
                          detail.genres![index].name,
                          maxLines: 2,
                          style: const TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.0),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
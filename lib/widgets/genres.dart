import 'package:flutter/material.dart';
import 'package:netflix/bloc/getGenre.dart';
import 'package:netflix/model/genre.dart';
import 'package:netflix/model/genreResponse.dart';

import 'genreList.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  GenresScreenState createState() => GenresScreenState();
}

class GenresScreenState extends State<GenresScreen>{


  @override
  void initState() {
    super.initState();
    genresBloc.getGenres();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
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
                valueColor:
                 AlwaysStoppedAnimation<Color>(Colors.white),
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

  Widget _buildHomeWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.isEmpty) {
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
      return GenresList(genres: genres,);
    }
  }
}
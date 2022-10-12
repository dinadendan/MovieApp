import 'package:flutter/material.dart';
import 'package:netflix/bloc/getMovieByGenre.dart';
import 'package:netflix/style/theme.dart' as Style;

import '../model/genre.dart';
import 'genreMovies.dart';

class GenresList extends StatefulWidget {
  final List<Genre> genres;
  const GenresList({ Key? key, required this.genres})
      : super(key: key);
  @override
  GenresListState createState() => GenresListState(genres);
}

class GenresListState extends State<GenresList> with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  GenresListState(this.genres);
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc.drainStream();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 307.0,
        child: DefaultTabController(
          length: genres.length,
          child: Scaffold(
            backgroundColor: Style.Colors.mainColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor: Style.Colors.mainColor,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Style.Colors.secondColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  unselectedLabelColor: Style.Colors.titleColor,
                  labelColor: Colors.white,
                  isScrollable: true,
                  tabs: genres.map((Genre genre) {
                    return Container(
                        padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                        child:  Text(genre.name.toUpperCase(), style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )));
                  }).toList(),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: genres.map((Genre genre) {
                return GenreMovies(genreId: genre.id,);
              }).toList(),
            ),
          ),
        ));
  }
}
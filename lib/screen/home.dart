import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:netflix/style/theme.dart' as Style;
import 'package:netflix/widgets/bestMovie.dart';
import 'package:netflix/widgets/nowPlaying.dart';
import '../widgets/genres.dart';


class Home extends StatelessWidget{
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        // leading: const Icon(EvaIcons.menu2Outline, color: Colors.white,),
        title: const Text("Discover"),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(EvaIcons.searchOutline, color: Colors.white,)
          )
        ],
      ),
      body: ListView(
        children: const <Widget>[
          NowPlaying(),
          GenresScreen(),
          // PersonsList(),
          BestMovies(),
        ],
      ),
    );
  }
}

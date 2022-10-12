import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netflix/bloc/getCast.dart';
import 'package:netflix/model/castResponse.dart';
import 'package:netflix/style/theme.dart' as Style;

import '../model/cast.dart';

class Casts extends StatefulWidget {
  final int id;
  const Casts({Key ?key, required this.id}) : super(key: key);
  @override
  CastsState createState() => CastsState(id);
}

class CastsState extends State<Casts> {
  final int id;
  CastsState(this.id);
  @override
  void initState() {
    super.initState();
    castsBloc.getCasts(id);
  }

  @override
  void dispose() {
    castsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child:  Text(
            "CASTS",
            style:  TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error!.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error!);
              }
              return _buildCastWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error as String);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
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

  Widget _buildCastWidget(CastResponse data) {
    List<Cast> casts = data.casts;
    if (casts.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text(
                  "No More Persons",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 140.0,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: casts.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(top: 10.0, right: 8.0),
              width: 100.0,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    casts[index].img == null
                        ? Hero(
                      tag: casts[index].id,
                      child: Container(
                        width: 70.0,
                        height: 70.0,
                        decoration:  const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Style.Colors.secondColor),
                        child: const Icon(
                          FontAwesomeIcons.userLarge,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Hero(
                      tag: casts[index].id,
                      child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            image:  DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w300/${casts[index].img}")),
                          )),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      casts[index].name,
                      maxLines: 2,
                      style: const TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      casts[index].character,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 1.4,
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 7.0),
                    ),
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
import 'package:flutter/material.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: myColors[ORANGE],
          expandedHeight: 400,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                  bottomRight: Radius.circular(90),
                ),
                color: myColors[PRIMARY],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'gg',
                      style: TextStyle(
                        fontFamily: "PlaypenSans",
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "D-",
                      style: TextStyle(
                        fontFamily: "PlaypenSans",
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // floating: true,
          pinned: true,
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: myColors[ORANGE],
                child: Text(
                  'List Item $index',
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}

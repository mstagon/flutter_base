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
        appBar: AppBar(
          backgroundColor: myColors[PRIMARY],
          title: const Text('Test CustomScrollView'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
          SliverAppBar(
            backgroundColor: myColors[ORANGE],
          expandedHeight: 400.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              'src/img/back.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: myColors[ORANGE],
                    child: Text('List Item $index',style: TextStyle(fontSize: 20),),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}

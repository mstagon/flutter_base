import 'package:flutter/material.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class Health extends StatefulWidget {

  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<Health> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health',
      home: Scaffold(
      ),
    );
  }
}

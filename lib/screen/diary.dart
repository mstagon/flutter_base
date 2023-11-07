import 'package:flutter/material.dart';

class Diary extends StatefulWidget {

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
      ),
    );
  }
}

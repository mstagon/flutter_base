import 'package:flutter/material.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

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
        backgroundColor: Colors.orange,
        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  TextButton(
                  child: Text("Back"),
                  onPressed: (){},
                ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.dehaze),
                    onPressed: (){},
                  )],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Diary",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              color: Colors.white,
              width: 300,
              height: 200,
              margin: EdgeInsets.only(
                top: 24,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Text("그림이 들어올 곳입니다~"),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 300,
              margin: EdgeInsets.only(
                top: 24,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
               ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("일기 내용"),
                ],
              ),
              ),
            ],
          ),
        ),
      );
  }
}

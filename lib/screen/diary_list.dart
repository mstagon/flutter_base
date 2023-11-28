import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screen/diary.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class DiaryList extends StatefulWidget {

  @override
  _DiaryListState createState() => _DiaryListState();
}
class _DiaryListState extends State<DiaryList> {
  bool extended = false;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'DiaryList',
      home: Scaffold(
        backgroundColor: Colors.orange,
        floatingActionButton: SizedBox(
          child: extendButton(),
        ),
        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  TextButton(
                    child: Text("Back"),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("DiaryList",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350,
              height: 70,
              margin: EdgeInsets.only(
                top: 30,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("20XX/ XX / XX   제목"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  FloatingActionButton extendButton() {
    return FloatingActionButton.extended(
      onPressed: (){
        setState(() {
          extended = !extended;
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Diary())
          );
        });
      },
      label: const Text('일기 생성'),
      isExtended: extended,
      icon: const Icon(
        Icons.add,
      ),
    );
  }
}

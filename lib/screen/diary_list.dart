import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screen/diary.dart';
import 'package:untitled1/screen/diaryshow.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class DiaryItem {
  final DateTime date;
  final String title;
  final String content;

  DiaryItem({
    required this.date,
    required this.title,
    required this.content,
  });
}



class DiaryList extends StatefulWidget {

  @override
  _DiaryListState createState() => _DiaryListState();
}
class _DiaryListState extends State<DiaryList> {
  bool extended = false;
  List<DiaryItem> diaryItems = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI(); // 비동기 호출
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiaryList',
      home: Scaffold(
        backgroundColor: Colors.orange,
        floatingActionButton: SizedBox(
          child: extendButton(),
        ),
        body: SingleChildScrollView(
          child:
            Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      TextButton(
                        child: Text("Back"),
                        onPressed: () {},
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: diaryItems.length,
                  itemBuilder: (context, index) {
                    return diaryBlock(
                      diaryItems[index].date,
                      diaryItems[index].title,
                      diaryItems[index].content,
                    );
                  },
                ),
              ],
            ),
        )
      ),
    );
  }

  DateTime parseDateString(String dateString) {
    try {
      if (dateString == null || dateString.isEmpty) {
        // dateString이 비어 있거나 null인 경우 예외 처리
        throw Exception('Date string is empty or null');
      }

      final formattedDate = DateFormat("yyyy-MM-dd").parse(dateString);
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e, dateString: $dateString');
      return DateTime.now();
    }
  }


  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse('https://72ab-203-230-197-70.ngrok-free.app/get_list/'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data != null && data is List<dynamic>) {
          setState(() {
            diaryItems = List.generate(
              data.length,
                  (i) => DiaryItem(
                date: parseDateString(data[i]['create_date'] ?? ''),
                title: data[i]['title'] ?? '',
                content: data[i]['content'] ?? '',
              ),
            );
          });
        } else {
          throw Exception('Invalid data format received from API');
        }
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print('Error fetching data from API: $e');
      // 에러 처리 또는 사용자에게 알리는 로직 추가
    }
  }



  FloatingActionButton extendButton() {
    return FloatingActionButton.extended(
      onPressed: () {
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

  Widget diaryBlock(DateTime date, String title, String content) {
    final formattedDate = DateFormat("yyyy-MM-dd").format(date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryShow(date: formattedDate, title: title, content: content),
          ),
        );
      },
      child: Container(
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
            Text("$formattedDate   $title"),
          ],
        ),
      ),
    );
  }
}


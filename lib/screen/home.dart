import 'dart:convert';
import 'package:untitled1/screen/calendar.dart';
import 'package:untitled1/component/bottom_drag_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class ScheduleItem {
  final String event_name;

  ScheduleItem({
    required this.event_name,
  });
}

class SolutionItem {
  final String content;

  SolutionItem({
    required this.content,
  });
}


/// This is the private State class that goes with MyStatefulWidget.
class _HomeState extends State<Home> {
  List<ScheduleItem> schedule = [];
  String solution = '';

  @override
  void initState() {
    super.initState();
    fetchEventDataFromAPI();
    fetchSolutionDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors[ORANGE],
        body: Stack(
          children: [
            Row(
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
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 55,top: 75),
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepOrangeAccent
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin : EdgeInsets.only(left: 80,top: 105),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(0,3)
                          )],
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("src/img/loginicon.png")
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100,left: 10),
                      width: 170,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 30,),
                              Text(
                                '개이름',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                              SizedBox(width: 20,),
                              Text('개 종류',
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w600),)
                            ],
                          ),
                          Divider(height: 1,),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text('나이')
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text('체중')
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30,top:300,right: 30),
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child:Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            'schedule',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: (){
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Calendar()));
                              });
                            },
                            icon: Icon(Icons.calendar_month),
                          ),
                          SizedBox(width: 15,)
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: schedule.length,
                        itemBuilder: (context, index) {
                          return scheduleBlock(
                            schedule[index].event_name,
                          );
                        },
                      ),
                    ]
                ),

            ),
            _buildBottomDrawer(context),
          ],
        ),
      );
  }
  Future<void> fetchEventDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse('https://9ee4-125-138-128-205.ngrok-free.app/get_calendar_events/'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data != null && data is List<dynamic>) {
          setState(() {
            schedule = List.generate(
              data.length,
                  (i) => ScheduleItem(
                    event_name: data[i]['event_name'] ?? '',
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
  Future<void> fetchSolutionDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse('https://9ee4-125-138-128-205.ngrok-free.app/get_solution/'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print('Received data from API: $data');

        if (data != null && data is Map<String, dynamic>) {
          // 만약 데이터가 Map 형태로 있고, 'content' 키가 있는 경우
          if (data.containsKey('content')) {
            setState(() {
              solution = data['content'] as String;
            });
          } else {
            throw Exception('Invalid data format received from API: Missing "content" key');
          }
        } else {
          throw Exception('Invalid data format received from API: Data is not a Map');
        }
      } else {
        throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from API: $e');
      // 에러 처리 또는 사용자에게 알리는 로직 추가
    }
  }
  Widget scheduleBlock(String event_name) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10,),
            Icon(Icons.note, color: Colors.green,),
            SizedBox(width: 10,),
            Text(
              '$event_name',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
  Widget _buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: 20,
      drawerHeight: 670,
      color: Colors.white,
      controller: _controller,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 60,
          spreadRadius: 5,
          offset: const Offset(2, -6), // changes position of shadow
        ),
      ],
    );
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        ],
      ),
    );
  }


  Widget _buildBottomDrawerBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'solution',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 15,),
            Text(
              solution.replaceAll('�', ''),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }


  BottomDrawerController _controller = BottomDrawerController();
}
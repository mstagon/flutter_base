import 'package:flutter/material.dart';
import 'package:untitled1/screen/home.dart';
import 'package:untitled1/screen/diary.dart';
import 'package:untitled1/screen/calendar.dart';
import 'package:untitled1/screen/chat.dart';
import 'package:untitled1/screen/health.dart';
import 'package:untitled1/screen/diary_list.dart';



const PRIMARY = "primary";
const ORANGE = "orange";
const BLACK = "black";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  BLACK: Colors.black
};

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin{    // ➊
  TabController? controller;  // 사용할 TabController 선언
  @override
  void initState() {
    super.initState();

    controller = TabController(length: 5, vsync: this);  // ➋

    controller!.addListener(tabListener);
  }

  tabListener() {
    setState(() {});
  }

  @override
  dispose(){
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      backgroundColor: myColors[ORANGE],
      bottomNavigationBar:
      Container(
        color: myColors[ORANGE],
        child : ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(color: Colors.deepOrange),
            unselectedIconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: myColors[PRIMARY],
            currentIndex: controller!.index,
            onTap: (int index) {
              setState(() {
                controller!.animateTo(index);
              });
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: myColors[PRIMARY],
                icon: Icon(
                  Icons.home,
                ),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                backgroundColor: myColors[PRIMARY],
                icon: Icon(
                  Icons.note,
                ),
                label: 'DIARY',
              ),
              BottomNavigationBarItem(
                backgroundColor: myColors[PRIMARY],
                icon: Icon(
                  Icons.note,
                ),
                label: 'CALENDAR',

              ),
              BottomNavigationBarItem(
                backgroundColor: myColors[PRIMARY],
                icon: Icon(
                  Icons.note,
                ),
                label: 'CHAT',
              ),
              BottomNavigationBarItem(
                backgroundColor: myColors[PRIMARY],
                icon: Icon(
                  Icons.note,
                ),
                label: 'HEALTH',
              ),
            ],
          ),
        ),
      ),
    );
  }



  List<Widget> renderChildren(){
    return [
      Home(),
      DiaryList(),
      Calendar(),
      Chat(),
      Health(),
      Diary()
    ];
  }

}

import 'package:flutter/material.dart';
import 'package:untitled1/screen/home.dart';
import 'package:untitled1/screen/diary.dart';

const PRIMARY = "primary";
const ORANGE = "orange";

const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
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

    controller = TabController(length: 2, vsync: this);  // ➋

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
        decoration: BoxDecoration(
          color: myColors[ORANGE],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
             ],
           ),
    child : ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: myColors[ORANGE],
          currentIndex: controller!.index,
          onTap: (int index) {
            setState(() {
              controller!.animateTo(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: myColors[WHITE],
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note,
              ),
              label: '일기',
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
      Diary(),
    ];
  }

}


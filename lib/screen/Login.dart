import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:untitled1/screen/navi.dart';
import 'package:untitled1/screen/profile_input.dart';

// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
// import 'package:social_login_app/login_platform.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LogInState();
}

class _LogInState extends State<Login> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffae3c),
      appBar: AppBar(
        // title: Text('Log in'),
        elevation: 0.0,
        backgroundColor: const Color(0xffffae3c),
        centerTitle: true,
        // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.search), onPressed: () {})
        // ],
      ),
      // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 50)),
              Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset(
                  'src/img/loginicon.png',
                  width: 170.0,
                ),
              )),
              Form(
                  child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: EdgeInsets.fromLTRB(50, 100, 50, 0),
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 5, left: 5),
                                  child: Text("Email",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                      )))),
                          TextField(
                            controller: controller,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              isDense: true,
                              // Added this
                              contentPadding: EdgeInsets.all(12), // Added this
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 5, left: 5),
                                  child: Text("비밀번호",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                      )))),
                          TextField(
                            controller: controller2,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              isDense: true,
                              // Added this
                              contentPadding: EdgeInsets.all(12), // Added this
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          ButtonTheme(
                              child: ElevatedButton(
                            onPressed: () {
                              if (controller.text == '1234' &&
                                  controller2.text == '1234') {
                                showSnackBar(context, Text('로그인 성공'));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RootScreen()));
                              } else if (controller.text ==
                                      'devcms21@gmail.com' &&
                                  controller2.text != '1234') {
                                showSnackBar(context, Text('Wrong password'));
                              } else if (controller.text !=
                                      'devcms21@gmail.com' &&
                                  controller2.text == '1234') {
                                showSnackBar(context, Text('Wrong email'));
                              } else {
                                showSnackBar(
                                    context, Text('Check your info again'));
                              }
                            },
                            child: Text(
                              '로그인',
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(400, 45),
                                backgroundColor: Color(0xffFF7629)),
                          )),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  child: Container(
                                    child: Text("비밀번호 찾기",
                                        style: TextStyle(
                                          color: Color(0xff757575),
                                        )),
                                  ),
                                ),
                                Align(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileInput()), // ProfileInput 대신 이동할 페이지로 변경
                                        );
                                      },
                                      child: Text(
                                        "회원가입",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlutterSocialButton(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RootScreen()));
                                    },
                                    buttonType: ButtonType.facebook,
                                    mini:
                                        true // Button type for different type buttons
                                    ),
                                // const SizedBox(width: 59.7,),
                                FlutterSocialButton(
                                    onTap: () {},
                                    buttonType: ButtonType.google,
                                    mini:
                                        true // Button type for different type buttons
                                    ),
                                // const SizedBox(width: 59.7,),
                                FlutterSocialButton(
                                    onTap: () {},
                                    buttonType: ButtonType.apple,
                                    mini:
                                        true // Button type for different type buttons
                                    ),
                              ]),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                        ],
                      );
                    })),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color.fromARGB(255, 112, 48, 48),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// class NextPage extends StatelessWidget {
//   const NextPage({Key key) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

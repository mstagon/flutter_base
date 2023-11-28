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

class Diary extends StatefulWidget {

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  final _contentEditController = TextEditingController();
  final _contentEditController2 = TextEditingController();
  String title = '';
  String text = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary',
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: 350,
                    height: 400,
                    margin: EdgeInsets.only(
                        top: 24,
                        bottom: 10
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                renderTextForm(
                                    validator: (val) {
                                      if(val.length < 1) {
                                        return '제목을 입력해 주세요';
                                      }
                                    },
                                    onSaved: (val) {
                                      setState(() {
                                        this.title = val;
                                      });
                                    },
                                    label: '제목',
                                    maxline: 1
                                ),
                                renderTextForm(
                                    validator: (val) {
                                      if(val.length < 1) {
                                        return '내용을 입력해 주세요';
                                      }
                                    },
                                    onSaved: (val) {
                                      setState(() {
                                        this.text = val;
                                      });
                                    },
                                    label: '내용',
                                    maxline: 9
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        final formKeyState = _formKey.currentState!;
                        if(formKeyState.validate()){
                          formKeyState.save();
                          sendDiaryToBackend(text, title);
                          _showAlert(context, "추가되었습니다.");
                        }
                      },
                      child: const Text('추가 하기'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  renderTextForm({
    required FormFieldValidator validator,
    required FormFieldSetter onSaved,
    required String label,
    required int maxline,

  }) {
    assert(onSaved != null);
    assert(validator != null);
    assert(label != null);
    assert(maxline != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700),

            )
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          style: TextStyle(fontSize: 20),
          maxLines: maxline,
        ),
        Container(height: 10)
      ],
    );
  }
  Future<void> _showAlert(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}




Future<String> sendDiaryToBackend(String text, String title) async {
  var url = Uri.parse('https://c46f-121-152-69-146.ngrok-free.app/posts/'); // Replace with your Flask server URL

  var response = await http.post(
    url,
    body: {
      "title": title,
      "content": text,
    },
  );
  return response.body;
}



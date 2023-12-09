import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled1/screen/diary_list.dart';

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
  DateTime selectedDate = DateTime.now();
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
                    height: 480,
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
                                    if (val == null) {
                                      return '날짜를 입력해 주세요';
                                    }
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      this.selectedDate = val;
                                    });
                                  },
                                  label: '날짜',
                                  maxline: 1,
                                  isDateField: true,
                                ),
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
                          sendDiaryToBackend(text, title, selectedDate);
                        }
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DiaryList()));
                        });
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
    bool isDateField = false,

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
        isDateField
            ? InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: '날짜를 선택하세요',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat("yyyy-MM-dd").format(selectedDate),
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        )
            : TextFormField(
          onSaved: onSaved,
          validator: validator,
          style: TextStyle(fontSize: 20),
          maxLines: maxline,
        ),
        Container(height: 10)
      ],
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}




Future<String> sendDiaryToBackend(String text, String title, DateTime date) async {
  var url = Uri.parse('https://aeea-203-237-200-33.ngrok-free.app/posts/'); // Replace with your Flask server URL

  // Format the date to send in "%Y-%m-%d" format
  var formattedDate = "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";

  var response = await http.post(
    url,
    body: {
      "title": title,
      "content": text,
      "date": formattedDate,
    },
  );
  return response.body;
}

String _twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  } else {
    return "0$n";
  }
}
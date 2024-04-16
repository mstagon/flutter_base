import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/screen/home.dart';
import 'package:http/http.dart' as http;

import 'navi.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class ProfileInput extends StatefulWidget {

  @override
  _ProfileInputState createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  String name = '';
  String breed = '';
  String age = '';
  String sex = '';
  String weight = '';
  String feed = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtileInput',
      home: Scaffold(
        backgroundColor: Colors.orange,
        floatingActionButton: SizedBox(
          child: extendButton(),
        ),
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '이름을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.name = val;
                          });
                        },
                        label: '이름',
                        maxline: 1,
                        hint: ''
                    ),
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '견종을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.breed = val;
                          });
                        },
                        label: '견종',
                        maxline: 1,
                        hint: ''
                    ),
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '나이을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.age = val;
                          });
                        },
                        label: '나이',
                        maxline: 1,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        hint: '1~20까지의 숫자만 입력해주세요'
                    ),
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '성별을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.sex = val;
                          });
                        },
                        label: '성별',
                        maxline: 1,
                        hint: '남 / 여 둘 중 하나만 입력해주세요'
                    ),
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '체중을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.weight = val;
                          });
                        },
                        label: '체중',
                        maxline: 1,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        hint: 'kg단위 입니다 숫자로 입력해주세요'
                    ),
                    renderTextForm(
                        validator: (val) {
                          if(val.length < 1) {
                            return '급여량을 입력해 주세요';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            this.feed = val;
                          });
                        },
                        label: '평균 일회 급여량',
                        maxline: 1,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        hint: 'g단위 입니다 숫자만 입력해주세요'
                    ),
                  ],
                ),
              )
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
    required String hint,
    List<TextInputFormatter>? inputFormatter,

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
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            hintText: hint,
              contentPadding: EdgeInsets.symmetric(vertical: 0)// 힌트 문구 추가
          ),
        ),
        Container(height: 10)
      ],
    );
  }
  FloatingActionButton extendButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        final formKeyState = _formKey.currentState!;
        if(formKeyState.validate()){
          formKeyState.save();
          sendDiaryToBackend(age, name, breed, sex, weight, feed);
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RootScreen()));
          });
        }
      },
      label: const Text('프로필 생성'),
      icon: const Icon(
        Icons.add,
      ),
    );
  }
}

Future<String> sendDiaryToBackend(String age, String name, String breed, String sex, String weight, String feed) async {
  var url = Uri.parse('https://72ab-203-230-197-70.ngrok-free.app/profile/'); // Replace with your Flask server URL


  var response = await http.post(
    url,
    body: {
      "age" : age,
      "name" : name,
      "breed" : breed,
      "sex" : sex,
      "weight" : weight,
      "feed" : feed
    },
  );
  return response.body;
}
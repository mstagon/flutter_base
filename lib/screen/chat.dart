import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white,
};

class Chat extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<Chat> {
  final List<ChatMessage> _messages = <ChatMessage>[
    // 초기화면에 봇의 첫 메시지 추가
    ChatMessage(
      text: '무슨 문제가 있습니까',
      isUserMessage: false,
    ),
  ];

  final TextEditingController _textController = TextEditingController();

  Future<String> sendDiaryToBackend(String text) async {
    var url = Uri.parse("https://72ab-203-230-197-70.ngrok-free.app/chat/solution/");

    var response = await http.post(
      url,
      body: {"prompt": text},
    );

    if (response.statusCode == 200) {
      // JSON 디코딩 후 'content' 필드를 반환
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData["content"] ?? 'Success';
    } else {
      return 'Failed';
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    // 사용자 메시지 추가
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUserMessage: true,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    // 챗봇 API 호출
    try {
      String botReply = await sendDiaryToBackend(text);

      // 챗봇 응답 메시지 추가
      ChatMessage botMessage = ChatMessage(
        text: botReply,
        isUserMessage: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error during API request: $e');
      // 에러를 처리하거나 사용자에게 알림
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors[ORANGE],
      body: Column(
        children: <Widget>[
          Text('AI Chat'),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: myColors[WHITE],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          isUserMessage
              ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('User', style: Theme.of(context).textTheme.subtitle1),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 150,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
              : Container(),
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: CircleAvatar(
              child: Text(isUserMessage ? 'U' : 'B'),
              backgroundColor: myColors[PRIMARY],
            ),
          ),
          isUserMessage
              ? Container()
              : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Bot', style: Theme.of(context).textTheme.subtitle1),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 170,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

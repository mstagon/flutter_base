import 'dart:convert';

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
    var url = Uri.parse('https://dd90-125-138-249-130.ngrok-free.app/bot/test/'); // Replace with your Flask server URL

    var response = await http.post(
      url,
      body: {'prompt': text},
    );

    if (response.statusCode == 200) {
      // JSON 디코딩 후 'content' 필드를 반환
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['content'] ?? 'Failed to get content from the API response';
    } else {
      return 'Failed to send the diary entry';
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
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
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
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: CircleAvatar(
              child: Text(isUserMessage ? 'U' : 'B'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(isUserMessage ? 'User' : 'Bot', style: Theme.of(context).textTheme.subtitle1),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';
import 'package:ohmygpt_mobile/service/service.dart';


const String url = "https://api.ohmygpt.com/v1/chat/completions";

List<Message> messages = [Message(id: '123', role: 0, content: 'hello, are you chatGPT?', conversationId: '123', upId: null)];
Conversation conversation = Conversation(title: 'new conversation', messages: messages, id: '123123123', stream: true);



Future<void> main() async {
  debugPrint(conversation.toRequestJson());
  conversation.stream = false;
  var res = await chatWithOpenAiWithoutStream(conversation.toRequestJson());
  print(res.toString());
}


Future chatWithOpenAI(String json) async {
  String apiKey = "sk-dIrwxhYDeRUtiJAcN1Bax5rxJrAcva0WlmxyuVBGwl9gWRNQ";
  try {
    // 根据httpClient创建dio对象
    final client = http.Client();
    final request = http.Request('POST', Uri.parse(url))
    ..headers.addAll({
      'Authorization': "Bearer $apiKey",
      'Content-Type': 'application/json'
    })
    .. body = json;
    final response = await client.send(request);
    final stream = response.stream.transform(utf8.decoder);
    print(stream.isEmpty);

    // 监听流并输出数据
    stream.listen((data) {
      print('Data received: $data');
    });
    return response;
  } catch (e) {
    print(e);
  }
}

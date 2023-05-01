import 'dart:math';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';

class ResponseMessage {
  Message message;
  String? finishReason;
  int index;

  ResponseMessage(this.message, this.finishReason, this.index);

  static ResponseMessage fromJson(Map<String, dynamic> map) {

    return ResponseMessage(
        Message(content: map['message']['content'], role: Message.ROLE_BOT, id: DateTime.now().millisecondsSinceEpoch.toString()+Random().nextInt(100).toString() ),
        map['finish_reason'],
        map['index']);
  }
}

Future<ResponseMessage> chatWithOpenAiWithoutStream(String json) async {
  String apiKey = "sk-dIrwxhYDeRUtiJAcN1Bax5rxJrAcva0WlmxyuVBGwl9gWRNQ";
  Response response;
  // 根据httpClient创建dio对象
  var dio = Dio();
  debugPrint(json);
  dio.httpClientAdapter = DefaultHttpClientAdapter();
  response = await dio.post(
      "https://o-api-mirror01.gistmate.hash070.com/v1/chat/completions",
      data: json,
      options: Options(
        headers: {"Authorization": "Bearer $apiKey"},
        contentType: Headers.jsonContentType,
      ));
  print(response.data['choices'][0]);
  return ResponseMessage.fromJson(response.data['choices'][0]);
}

Future chatWithOpenAI(String json) async {}

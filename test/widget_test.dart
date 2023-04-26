// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';

Future<void> main() async {
  String msg = '{"role":"user","text":"你好", "name":"1"}';
  Message message = Message.fromJson(msg);
  print(message);

}

Future chatWithOpenAI(String json) async {
  String apiKey = "sk-dIrwxhYDeRUtiJAcN1Bax5rxJrAcva0WlmxyuVBGwl9gWRNQ";
  Response response;
  try {
    // 根据httpClient创建dio对象
    var dio = Dio();
    dio.httpClientAdapter = DefaultHttpClientAdapter();
    response =
    await dio.post(
        "https://o-api-mirror01.gistmate.hash070.com/v1/chat/completions",
        data: json,
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey"
          },
          contentType: Headers.jsonContentType,

        ));
    return response;
  } catch (e) {
    print(e);
  }
}

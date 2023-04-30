import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';



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
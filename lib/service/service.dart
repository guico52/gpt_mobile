import 'dart:convert';
import 'package:dio/dio.dart';

class OpenAIService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.openai.com/v1/engines/language-davinci/jobs';

  Future<String> chat(String prompt) async {
    try {
      Response response = await _dio.post(
        _baseUrl,
        data: jsonEncode({
          "prompt": prompt,
          "max_tokens": 100,
          "temperature": 1,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer <YOUR_API_KEY>',
          },
        ),
      );

      Map<String, dynamic> result = jsonDecode(response.data);
      return result['choices'][0]['text'];
    } catch (e) {
      print(e);
      return 'Error occured while communicating with the OpenAI language model.';
    }
  }
}

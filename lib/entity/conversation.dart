import 'package:ohmygpt_mobile/screen/home_views/conversation.dart';

class Conversation {
  final String id;
  final List<Message> messages;
  late String _model;
  final String title;
  late double _temperature;
  late double _topP;
  late int _n;
  late bool _stream;
  late int _maxTokens;
  late double _presencePenalty;
  late double _frequencyPenalty;
  late String _stop;

  Conversation({
    required this.messages,
    required this.id,
    required this.title,
      String model = 'gpt-3.5-turbo',
      double temperature = 1,
      double topP = 1,
      bool stream = false,
      int maxTokens = 100,
      double presencePenalty = 0,
      double frequencyPenalty = 0,
      String stop = ''}){
    _model = model;
    _temperature = temperature;
    _topP = topP;
    _n = messages.length;
    _stream = stream;
    _maxTokens = maxTokens;
    _presencePenalty = presencePenalty;
    _frequencyPenalty = frequencyPenalty;
    _stop = stop;

  }


  String toRequestJson() {
    return '{"messages": ${messages.map((e) => e.toRequestJson()).toList()}, '
        '"model": "$_model", '
        '"temperature": $_temperature, '
        '"top_p": $_topP, '
        '"n": $_n, '
        '"stream": $_stream, '
        '"max_tokens": $_maxTokens, '
        '"presence_penalty": $_presencePenalty, '
        '"frequency_penalty": $_frequencyPenalty, '
        '"stop": "$_stop"}';
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'model': _model,
      'title': title,
      'temperature': _temperature,
      'top_p': _topP,
      'n': _n,
      'stream': _stream,
      'max_tokens': _maxTokens,
      'presence_penalty': _presencePenalty,
      'frequency_penalty': _frequencyPenalty,
      'stop': _stop,
    };
  }

  Session toSession(){
    return Session(id: id, title: title);
  }
}

class Message {
  String id;
  String role;
  String content;
  String conversationId;
  String upId;

  Message(
      {required this.id,
      required this.role,
      required this.content,
      required this.conversationId,
      required this.upId});

  // 用于发送请求，因此不需要id
  String toRequestJson() {
    // 将content中的双引号进行处理，防止发送到服务器时出错
    content = content.replaceAll('"', r'\"');
    return '{"role": "$role", "content": "$content"}';
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'role': role,
      'content': content,
      'conversation_id': conversationId,
      'up_id': upId,
    };
  }
}

import 'package:ohmygpt_mobile/screen/home_views/conversation.dart';

class Conversation {
  final String id;
  final List<Message> messages;
  late String model;
  final String title;
  late double temperature;
  late int topP;
  late int n;
  late bool stream;
  late int maxTokens;
  late double presencePenalty;
  late double frequencyPenalty;
  late String stop;

  Conversation({
    required this.messages,
    required this.id,
    required this.title,
    this.model = 'gpt-3.5-turbo',
    this.temperature = 0.7,
    this.topP = 1,
    this.n = 1,
    this.stream = false,
    this.maxTokens = 100,
    this.presencePenalty = 0,
    this.frequencyPenalty = 0,
    this.stop = '',
  });

  String toRequestJson() {
    return '{"messages": ${messages.map((e) => e.toRequestJson()).toList()}, '
        '"model": "$model", '
        '"temperature": $temperature, '
        '"top_p": $topP, '
        '"n": $n, '
        '"stream": $stream, '
        '"max_tokens": $maxTokens, '
        '"presence_penalty": $presencePenalty, '
        '"frequency_penalty": $frequencyPenalty, '
        '"stop": "$stop"}';
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'model': model,
      'title': title,
      'temperature': temperature,
      'topp': topP,
      'n': n,
      'stream': stream ? 1 : 0, // 将bool转换为int,存储到数据库中
      'maxtokens': maxTokens,
      'presencepenalty': presencePenalty,
      'frequencypenalty': frequencyPenalty,
      'stop': stop,
    };
  }

  Session toSession() {
    return Session(id: id, title: title);
  }
}

class Message {
  String id;
  int role;
  String content;
  String conversationId;
  String? upId;

  static const int ROLE_USER = 0;
  static const int ROLE_BOT = 1;
  static const int ROLE_SYSTEM = 2;

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
    return '{"role": "${switchRole()}", "content": "$content"}';
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

  String switchRole() {
    switch (role) {
      case 0:
        return 'user';
      case 1:
        return 'assistant';
      case 2:
        return 'system';
      default:
        return 'user';
    }
  }
}

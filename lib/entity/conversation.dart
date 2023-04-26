import 'dart:convert';

class Conversation {
  final String sessionId;
  final List<Message> _messages;
  final String _model;
  final ConversationSetting _setting;

  Conversation(this._messages, this._model, this.sessionId, this._setting) ;

  String toRequestJson() {
    return '{"messages": ${_messages.map((e) => e.toJson()).toList()}, '
        '"model": "$_model", '
        '"temperature": ${_setting._temperature}, '
        '"top_p": ${_setting._topP}, '
        '"n": ${_setting._n}, '
        '"stream": ${_setting._stream}, '
        '"max_tokens": ${_setting._maxTokens}, '
        '"presence_penalty": ${_setting._presencePenalty}, '
        '"frequency_penalty": ${_setting._frequencyPenalty}, '
        '"stop": "${_setting._stop}"}';
  }

  String toJson(){
    return json.encoder.convert(this);
  }

  Conversation fromJson(String str){
    Map<String, dynamic> json = jsonDecode(str);
    return Conversation(
      json['messages'],
      json['model'],
      json['sessionId'],
      json['setting'],
    );
  }
}

class Message {
  String role;
  String content;
  String? name;

  Message(this.role, this.content, [String? name]) {
    this.name = name ?? '';
  }

  String toJson() {
    // 将content中的双引号进行处理，防止发送到服务器时出错
    content = content.replaceAll('"', r'\"');
    if (name == null || name == '') {
      return '{"role": "$role", "content": "$content"}';
    }
    return '{"role": "$role", "content": "$content", "name": "$name"}';
  }

  static Message fromJson(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return Message(json['role'], json['content'], json['name']);
  }
  static List<Message> fromJsonList(String jsonStr) {
    List<dynamic> json = jsonDecode(jsonStr);
    return json.map((e) => Message.fromJson(e)).toList();
  }
}

class ConversationSetting {
  late double _temperature;
  late double _topP;
  late int _n;
  late bool _stream;
  late int _maxTokens;
  late double _presencePenalty;
  late double _frequencyPenalty;
  late String _stop;

  ConversationSetting(
      double? temperature,
      double? topP,
      int? n,
      bool? stream,
      int? maxTokens,
      double? presencePenalty,
      double? frequencyPenalty,
      String? stop) {
    _temperature = temperature ?? 0.9;
    _topP = topP ?? 1;
    _n = n ?? 1;
    _stream = stream ?? false;
    _maxTokens = maxTokens ?? 64;
    _presencePenalty = presencePenalty ?? 0;
    _frequencyPenalty = frequencyPenalty ?? 0;
    _stop = stop ?? r'\n';
  }

  String toJson(){
    return json.encoder.convert(this);
  }

  ConversationSetting fromJson(String jsonStr){
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return ConversationSetting(
      json['temperature'],
      json['top_p'],
      json['n'],
      json['stream'],
      json['max_tokens'],
      json['presence_penalty'],
      json['frequency_penalty'],
      json['stop'],
    );
  }
}

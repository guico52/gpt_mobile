import 'package:sqflite/sqflite.dart';

import '../entity/conversation.dart';
import '../entity/prompt.dart';
import '../screen/home_views/conversation.dart';
// ================================================= init ================================================

Future<void> initDB() async {
  final db = await openDatabase("gpt.db", version: 1, onCreate: (db, version) async {
    await db.execute(
        "CREATE TABLE Message (id TEXT PRIMARY KEY, content TEXT, role INTEGER, conversation_id INTEGER, up_id TEXT)");
    await db.execute("CREATE TABLE Conversation (id TEXT PRIMARY KEY, title TEXT, model TEXT, temperature REAL, top_p REAL, n INTEGER, stream INTEGER, max_tokens INTEGER, presence_penalty REAL, frequency_penalty REAL, stop TEXT)");
    await db.execute("CREATE TABLE Prompt (id TEXT PRIMARY KEY,title TEXT, content TEXT)");
  });
}
Future<Database> getDB() async {
  return await openDatabase("gpt.db");
}
// ================================================= Message ================================================
Future<void> insertMessage(Message message) async {
  final db = await getDB();
  await db.insert("Message", message.toMap());
}

Future<void> updateMessage(Message message) async {
  final db = await getDB();
  await db.update("Message", message.toMap(), where: "id = ?", whereArgs: [message.id]);
}

Future<List<Message>> getAllMessages(String conversationId) async {
  final db = await getDB();
  final List<Map<String, dynamic>> maps = await db.query("Message", where: "conversation_id = ?", whereArgs: [conversationId]);
  return List.generate(maps.length, (i) {
    return Message(
      id: maps[i]['id'],
      role: maps[i]['role'],
      content: maps[i]['content'],
      conversationId: maps[i]['conversation_id'],
      upId: maps[i]['up_id'],
    );
  });
}

Future<List<Message>> getUpMessages(String conversationId, String id) async{
  final db = await getDB();
  final List<Map<String, dynamic>> maps = await db.rawQuery(
   'WITH RECURSIVE cte (id, content, role, conversation_id, up_id) AS ('
      'SELECT id, content, role, conversation_id, up_id'
      'FROM Message'
  'WHERE id = ?'
  'UNION ALL'
      'SELECT Message.id, Message.content, Message.role, Message.conversation_id, Message.up_id'
  'FROM cte'
      'JOIN Message ON cte.up_id = Message.id'
  ')'
  'SELECT * FROM cte LIMIT n;'
  );
  return List.generate(maps.length, (i) {
    return Message(
      id: maps[i]['id'],
      role: maps[i]['role'],
      content: maps[i]['content'],
      conversationId: maps[i]['conversation_id'],
      upId: maps[i]['up_id'],
    );
  });
}

// ================================================= Conversation ================================================

Future<void> insertConversation(Conversation conversation) async {
  final db = await getDB();
  await db.insert("Conversation", conversation.toMap());
}

Future<Conversation> getConversationById(String id) async {
  final db = await getDB();
  final List<Map<String, dynamic>> maps = await db.query("Conversation", where: "id = ?", whereArgs: [id]);
  List<Message> messages = await getAllMessages(id);
  return Conversation(
    messages: messages,
    id: maps[0]['id'],
    model: maps[0]['model'],
    title: maps[0]['title'],
    temperature: maps[0]['temperature'],
    topP: maps[0]['top_p'],
    stream: maps[0]['stream'],
    maxTokens: maps[0]['max_tokens'],
    presencePenalty: maps[0]['presence_penalty'],
    frequencyPenalty: maps[0]['frequency_penalty'],
    stop: maps[0]['stop'],
  );
}
Session _sessionFromMap(Map<String, dynamic> map) {
  return Session(
    id: map['id'],
    title: map['title'],
  );
}
Future<void> deleteConversationById(String id) async {
  final db = await getDB();
  await db.delete("Conversation", where: "id = ?", whereArgs: [id]);
}
// 获取所有Session
Future<List<Session>> getAllSessions() async{
  final db = await getDB();
  final List<Map<String, dynamic>> maps = await db.query("Conversation");
  return List.generate(maps.length, (i) {
    return _sessionFromMap(maps[i]);
  });
}

// ================================================= Prompt ================================================
Future<void> insertPrompt(Prompt prompt) async {
  final db = await getDB();
  await db.insert("Prompt", prompt.toMap());
}

Future<void> deletePromptById(String id) async {
  final db = await getDB();
  await db.delete("Prompt", where: "id = ?", whereArgs: [id]);
}

Future<void> updatePrompt(Prompt prompt) async {
  final db = await getDB();
  await db.update("Prompt", prompt.toMap(), where: "id = ?", whereArgs: [prompt.id]);
}

Future<List<Prompt>> getAllPrompts() async {
  final db = await getDB();
  final List<Map<String, dynamic>> maps = await db.query("Prompt");
  return List.generate(maps.length, (i) {
    return Prompt(
      id: maps[i]['id'],
      content: maps[i]['content'],
      title: maps[i]['title'],
    );
  });
}




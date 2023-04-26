/// 包含当前用户所有会话列表的页面
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/dao/dao.dart';

import '../../entity/conversation.dart';
import '../../entity/session.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {

  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    _fetchSessions();

  }

  final TextEditingController _sessionTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('会话',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal)),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              // 调用方法进行挂载
              onPressed: addNewSession,
            ),
          ],
        ),
        body: ListView.builder(
            key: Key(sessions.hashCode.toString()),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return SessionInfo(
                  id: sessions[index].id,
                  title: sessions[index].title,
                  textEditingController: _sessionTitleController,
                  deleteSession: () => {
                        deleteSession(sessions[index].id),
                      });
            }));
  }

  void addNewSession() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('添加新的会话'),
              content: TextField(
                controller: _sessionTitleController,
                decoration: const InputDecoration(
                  hintText: '请输入会话标题',
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('确定'),
                  onPressed: () {
                    _addSession(_sessionTitleController.text);
                    Navigator.of(context).pop();
                    _sessionTitleController.clear();
                  },
                ),
              ],
            ));
  }

  void deleteSession(String sessionId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('删除会话'),
          content: const Text('确定删除会话吗？'),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                setState(() {
                  _deleteSession(sessionId);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  Future<void> _fetchSessions() async {
    final sessionList = await getAllSessions();
    setState(() {
      sessions = sessionList;
    });
  }

  void _addSession(String title) {
    String id = DateTime.now().millisecondsSinceEpoch.toString() +
                Random().nextInt(100).toString();
    Conversation conversation = Conversation(
      id: id,
      title: title,
      messages: [],
    );
    insertConversation(conversation);
    _fetchSessions();
  }

  void _deleteSession(String id) {
    deleteConversationById(id);
    _fetchSessions();
  }

}

class Session {
  final String id;
  final String title;

  Session({
    required this.id,
    required this.title
  });
}

class SessionInfo extends StatefulWidget {
  final String id;
  final String title;
  final TextEditingController textEditingController;

  // 回调函数，用于删除组件
  final VoidCallback deleteSession;

  const SessionInfo({
    super.key,
    required this.id,
    required this.title,
    required this.deleteSession,
    required this.textEditingController,
  }); // 系统预设信息

  @override
  State<StatefulWidget> createState() => SessionInfoState();
}

class SessionInfoState extends State<SessionInfo> {
  late String id;
  late String title;

  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    title = widget.title;
    _textEditingController = widget.textEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5)))),
      padding: const EdgeInsets.only(top: 15, bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xff999999),
            size: 30,
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, height: 2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          const SizedBox(width: 16.0),
          GestureDetector(
            onTap: updateTitle,
            child: const Icon(
              Icons.edit_outlined,
              color: Color(0xff999999),
              size: 30,
            ),
          ),
          const SizedBox(width: 16.0),
          GestureDetector(
            // TODO: 调用了回调函数，需要在函数体内添加删除请求
            onTap: widget.deleteSession,
            child: const Icon(
              Icons.delete_forever_outlined,
              color: Color(0xff999999),
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  void updateTitle() {
    _textEditingController.text = title;
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("修改标题"),
          content: TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "请输入新标题",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              // TODO: 修改标题
              onPressed: () => {Navigator.pop(context)},
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () => {
                setState(() {
                  title = _textEditingController.text;
                }),
                Navigator.pop(context),
                _textEditingController.clear()
              },
            )
          ],
        ));
  }
}


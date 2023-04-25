/// 包含当前用户所有会话列表的页面
import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/widget/conversaton/session.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
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
                      sessions = List.from(sessions)
                        ..removeWhere(
                            (element) => element.sessionId == sessionId);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  List<Session> sessions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessions = [
      Session(
          sessionId: '1', title: '1', userId: '1', robotId: 1, message: '1'),
      Session(
          sessionId: '2', title: '2', userId: '2', robotId: 2, message: '2'),
      Session(
          sessionId: '3', title: '3', userId: '3', robotId: 3, message: '3'),
      Session(
          sessionId: '4', title: '4', userId: '4', robotId: 4, message: '4'),
      Session(
          sessionId: '5',
          title:
              '这是一段很行很长的文本这是一段很行很长的文本这是一段很行很长的文本这是一段很行很长的文本这是一段很行很长的文本这是一段很行很长的文本',
          userId: '5',
          robotId: 5,
          message: '5'),
    ];
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
            key: Key(sessions.length.toString()),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return SessionInfo(
                  sessionId: sessions[index].sessionId,
                  title: sessions[index].title,
                  userId: sessions[index].userId,
                  robotId: sessions[index].robotId,
                  message: sessions[index].message,
                  textEditingController: _sessionTitleController,
                  deleteSession: () => {
                        deleteSession(sessions[index].sessionId),
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
                    // TODO: 记得发送请求
                    setState(() {
                      var nowIndex = sessions.length + 1;
                      sessions.add(Session(
                        sessionId: nowIndex.toString(),
                        title: _sessionTitleController.text,
                        userId: nowIndex.toString(),
                        robotId: nowIndex,
                        message: nowIndex.toString(),
                      ));
                    });
                    Navigator.of(context).pop();
                    _sessionTitleController.clear();
                  },
                ),
              ],
            ));
  }
}

class Session {
  final String sessionId;
  final String title;
  final String userId;
  final int robotId;
  final String message;

  Session(
      {required this.sessionId,
      required this.title,
      required this.userId,
      required this.robotId,
      required this.message});

  @override
  String toString() {
    // 调试的时候使用
    return 'Session{sessionId: $sessionId, title: $title, userId: $userId, robotId: $robotId, message: $message}';
  }
}

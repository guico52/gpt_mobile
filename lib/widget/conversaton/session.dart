/// 展示简略的Session信息，并提供编辑标题和删除功能
import 'package:flutter/material.dart';

class SessionInfo extends StatefulWidget {
  final String sessionId;
  final String title;
  final String userId;
  final int robotId;
  final String message;
  final TextEditingController textEditingController;

  // 回调函数，用于删除组件
  final VoidCallback deleteSession;

  const SessionInfo({
    super.key,
    required this.sessionId,
    required this.title,
    required this.userId,
    required this.robotId,
    required this.message,
    required this.deleteSession,
    required this.textEditingController,
  }); // 系统预设信息

  @override
  State<StatefulWidget> createState() => SessionInfoState();
}

class SessionInfoState extends State<SessionInfo> {
  late String sessionId;
  late String title;
  late String userId;
  late int robotId;
  late String message; // 系统预设信息

  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    sessionId = widget.sessionId;
    title = widget.title;
    userId = widget.userId;
    robotId = widget.robotId;
    message = widget.message;
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

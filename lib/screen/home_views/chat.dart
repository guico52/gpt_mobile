
import 'package:flutter/cupertino.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';

import '../../dao/dao.dart';

class ChatPage extends StatefulWidget{
  String conversationId;

  ChatPage({Key? key, required this.conversationId}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage>{
  late Conversation conversation;

  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  }

  Future<void> _fetchConversation() async {
    final conversation = await getConversationById(widget.conversationId);
    setState(() {
      this.conversation = conversation;
    });
  }

  Future<void> _fetchMessages() async {
    final messages = await getMessagesByConversationId(widget.conversationId);
    setState(() {
      this.messages = messages;
    });
  }
}
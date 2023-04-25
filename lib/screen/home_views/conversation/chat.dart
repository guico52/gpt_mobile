
import 'package:flutter/cupertino.dart';

class ChatPage extends StatefulWidget{
  const ChatPage({super.key});
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class BubbleInfo{
  final String text;
  final int role;

  const BubbleInfo({
    required this.text,
    required this.role,
  });

}
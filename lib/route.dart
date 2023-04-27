import 'package:flutter/cupertino.dart';
import 'package:ohmygpt_mobile/screen/home_views/chat.dart';
import 'package:ohmygpt_mobile/screen/home_views/conversation.dart';

final routes = {
  '/chat' : (context) => ChatPage(  session: ModalRoute.of(context)!.settings.arguments as Session),
};
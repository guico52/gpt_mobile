import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';

import '../../dao/dao.dart';
import 'conversation.dart';

class ChatPage extends StatefulWidget {
  final Session session;

  const ChatPage({Key? key, required this.session}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late Conversation _conversation;
  List<Message> _messages = [];

  bool _isDataLoaded = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conversation = Conversation(
      id: widget.session.id,
      title: widget.session.title,
      messages: [],
    );
    _initConversation();
  }

  @override
  Widget build(BuildContext context) {
    return _buildChatScreen();
  }

  Widget _buildChatScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_conversation.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: change conversation settings
            },
          ),
        ],
      ),
      body:SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: _messages[index],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: '输入消息',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> _fetchConversation() async {
    final conversation = await getConversationById(widget.session.id);
    final messages = await getMessagesByConversationId(widget.session.id);
    setState(() {
      _conversation = conversation;
      _messages = messages;
      _isDataLoaded = true;
    });
  }

  Future<void> _fetchMessages() async {
    final messages = await getMessagesByConversationId(widget.session.id);
    setState(() {
      _messages = messages;
    });
  }

  void _initConversation() {
    _fetchConversation();
  }

  void _sendMessage() async {
    final message = Message(
      content: _textEditingController.text,
      conversationId: widget.session.id,
      id: DateTime.now().millisecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      role: Message.ROLE_USER,
      upId: _messages[_messages.length - 1].id,
    );
    await insertMessage(message);
    _textEditingController.clear();
    _fetchMessages();
  }
}

class MessageBubble extends StatefulWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  MessageBubbleState createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  late Message message;
  final List<String> _userRoles = ['系统预设', '用户', 'ChatGPT'];
  String _selectedRole = '用户';
  bool _showPresetInput = false;

  @override
  void initState() {
    super.initState();
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _getIconByRole(), // ICON
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedRole,
                items: _userRoles
                    .map((role) => DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                      _showPresetInput = newValue == 'System Preset';
                    });
                  }
                },
              ),
              if (_showPresetInput)
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the title for system preset',
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message.content),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('编辑'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('删除'),
                ),
              ],
              onSelected: (String action) {
                // Handle actions here
                if (action == 'edit') {
                  _editMessage();
                } else if (action == 'delete') {
                  _deleteMessage();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _editMessage() {}

  void _deleteMessage() {}

  Icon _getIconByRole() {
    switch (message.role) {
      case Message.ROLE_USER:
        return const Icon(Icons.person);
      case Message.ROLE_SYSTEM:
        return const Icon(Icons.settings);
      case Message.ROLE_BOT:
        return const Icon(Icons.chat_bubble);
      default:
        return const Icon(Icons.person);
    }
  }
}

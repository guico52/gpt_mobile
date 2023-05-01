import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/entity/conversation.dart';
import 'package:ohmygpt_mobile/entity/prompt.dart';
import 'package:ohmygpt_mobile/service/service.dart';

import '../../dao/dao.dart';
import '../../widget/settingDialog.dart';
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
  List<Prompt> _prompts = [];

  bool _isDataLoaded = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _bubbleEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    _loadStateData();
  }

  @override
  Widget build(BuildContext context) {
    return _isDataLoaded ? _buildChatScreen() : _buildLoadingScreen();
  }

  // 未获取信息时，显示加载界面
  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('加载中...',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // 获取信息后，构建聊天界面
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
                onPressed: _showSettingDialog),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  key: Key(_messages.hashCode.toString() +
                      _messages.length.toString()),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: _messages[index],
                      prompts: _prompts,
                      deleteCallBack: () => {
                        deleteMessageById(_messages[index].id!)
                            .then((value) => setState(() {
                                  _fetchMessages();
                                }))
                      },
                      bubbleEditingController: _bubbleEditingController,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
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
        ));
  }

  void _showSettingDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (BuildContext context) {
          return const SettingDialog();
        });
    if (result == null) {
      return;
    }
    setState(() {
      _conversation.model = result['model'];
      _conversation.temperature = result['temperature'];
      _conversation.topP = result['topP'];
      _conversation.n = result['n'];
      _conversation.maxTokens = result['maxTokens'];
      _conversation.presencePenalty = result['presencePenalty'];
      _conversation.frequencyPenalty = result['frequencyPenalty'];
    });
  }

// 获取会话信息，包括设定和消息
  void _loadStateData() {
    getConversationById(widget.session.id).then((value) => {
          debugPrint("开始获取conversation"),
          setState(() {
            _conversation = value;
            _messages = _conversation.messages;
            _isDataLoaded = true;
          }),
        });
    getAllPrompts().then((value) => {
          setState(() {
            _prompts = value;
          }),
        });
  }

// 获取消息
  void _fetchMessages() {
    getMessagesByConversationId(widget.session.id).then((value) => setState(() {
          _messages = value;
        }));
  }

// 发送消息
  void _sendMessage() async {
    final message = Message(
      content: _textEditingController.text,
      conversationId: widget.session.id,
      id: DateTime.now().millisecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      role: Message.ROLE_USER,
      upId: _messages.isEmpty ? null : _messages[_messages.length - 1].id,
    );
    insertMessage(message)
        .then((value) => {_textEditingController.clear(), _fetchMessages()});
    if (!_conversation.stream) {
      chatWithOpenAiWithoutStream(_conversation.toRequestJson())
          .then((value) => {
                insertMessage(value.message),
                setState(() {
                  _messages.add(value.message);
                })
              });
    }
  }
}

class MessageBubble extends StatefulWidget {
  final Message message;

  final VoidCallback deleteCallBack;
  final TextEditingController bubbleEditingController;
  final List<Prompt> prompts;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.deleteCallBack,
      required this.bubbleEditingController,
      required this.prompts})
      : super(key: key);

  @override
  MessageBubbleState createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  late TextEditingController _bubbleEditingController;

  late Message message;
  final List<String> _userRoles = ['用户', 'ChatGPT', '系统预设'];
  late int _selectedRoleIndex ;
  bool _showPresetInput = false;
  bool _isEditing = false;

  late VoidCallback _deleteCallBack;
  late List<Prompt> _prompts;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    _selectedRoleIndex = message.role;
    _deleteCallBack = widget.deleteCallBack;
    _prompts = widget.prompts;
    _bubbleEditingController = widget.bubbleEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            key: Key(message.hashCode.toString() +
                _showPresetInput.toString() +
                _isEditing.toString()),
            children: [
              _getIconByRole(), // ICON
              const SizedBox(width: 8),
              if(!_isEditing)
                Text(_userRoles[message.role])
              else
              DropdownButton<String>(
                value: _userRoles[_selectedRoleIndex],
                items: [0, 1, 2]
                    .map((roleIndex) => DropdownMenuItem<String>(
                        value: _userRoles[roleIndex],
                        child: Text(_userRoles[roleIndex])))
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRoleIndex = _userRoles.indexOf(newValue);
                      _showPresetInput = newValue == _userRoles[2];
                      message.role = _selectedRoleIndex;
                    });
                  }
                },
              ),
              if (_showPresetInput)
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                      width: 150,
                      child: Autocomplete(
                          onSelected: (Prompt prompt) {
                            setState(() {
                              message.content = prompt.content;
                            });
                          },
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<Prompt>.empty();
                            }
                            return widget.prompts.where((prompt) =>
                                prompt.content.contains(textEditingValue.text));
                          },
                          displayStringForOption: (Prompt option) =>
                              option.title,
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              decoration: const InputDecoration(
                                hintText: '输入prompt标题',
                              ),
                            );
                          })),
                ),
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              key: Key(_isEditing.toString()),
              children: [
                if (_isEditing)
                  Expanded(
                      child: TextField(
                    controller: _bubbleEditingController,
                    decoration: const InputDecoration(
                      hintText: '输入消息',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ))
                else
                  Flexible(child: Text(message.content)),
              ],
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            key: Key(_isEditing.toString()),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (_isEditing)
                  Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: Row(children: [
                          TextButton(
                              onPressed: _editMessageFinished,
                              child: const Text("修改")),
                          TextButton(
                              onPressed: _editMessageCancled,
                              child: const Text("取消")),
                        ]),
                      ))
                else
                  Align(
                    alignment: Alignment.bottomRight,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
                          _deleteCallBack();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // 编辑消息
  void _editMessage() {
    _bubbleEditingController.text = message.content;
    setState(() {
      _isEditing = true;
    });
  }

  // 消息编辑完成
  void _editMessageFinished() {
    debugPrint(_bubbleEditingController.text);
    setState(() {
      message.content = _bubbleEditingController.text;
    });
    debugPrint(message.content);
    updateMessage(message).then((value) => {
          setState(() {
            _isEditing = false;
          })
        });
    debugPrint(message.content);
  }

  // 消息编辑取消
  void _editMessageCancled() {
    setState(() {
      _bubbleEditingController.clear();
      _isEditing = false;
    });
  }

  Icon _getIconByRole() {
    debugPrint(_selectedRoleIndex.toString());
    switch (_selectedRoleIndex) {
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

class StreamMessageBubble extends StatefulWidget {
  const StreamMessageBubble({super.key});

  @override
  State<StatefulWidget> createState() => StreamMessageBubbleState();
}

class StreamMessageBubbleState extends State<StreamMessageBubble> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

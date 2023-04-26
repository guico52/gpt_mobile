import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/dao/dao.dart';
import 'package:ohmygpt_mobile/widget/alertDialog.dart';

import '../../entity/prompt.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({Key? key}) : super(key: key);

  @override
  PromptPageState createState() => PromptPageState();
}

class PromptPageState extends State<PromptPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  List<Prompt> prompts = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchPrompts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Prompt仓库',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal)),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: addNewPrompt,
            ),
          ],
        ),
        body: ListView.builder(
          key: Key(prompts.hashCode.toString()),
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            return PromptInfo(
              prompt: prompts[index],
              titleController: titleController,
              contentController: contentController,
              deleteCallback: () => deleteCallBack(prompts[index].id),
              updateCallback: () => updateCallBack(prompts[index]),
            );
          },
        ));
  }

  void addNewPrompt() {
    showDialog(
        context: context,
        builder: (BuildContext context) => PromptAlertDialog(
            titleController: titleController,
            contentController: contentController,
            callBackFunction: () => {
                  setState(() {
                    _addPrompt(Prompt(
                        // id为时间戳+随机数
                        id: DateTime.now().millisecondsSinceEpoch.toString() +
                            Random().nextInt(100).toString(),
                        title: titleController.text,
                        content: contentController.text));
                  }),
                  Navigator.of(context).pop(),
                  titleController.clear(),
                  contentController.clear(),
                }));
  }

  void updateCallBack(Prompt prompt) {
    showDialog(
        context: context,
        builder: (context) => PromptAlertDialog(
            titleController: titleController,
            contentController: contentController,
            callBackFunction: () => {
                  setState(() {
                    _updatePrompt(Prompt(
                        id: prompt.id,
                        title: titleController.text,
                        content: contentController.text));
                  }),
                  Navigator.of(context).pop(),
                  titleController.clear(),
                  contentController.clear(),
                }));
  }

  void deleteCallBack(String id) {
    deletePromptById(id);
    _fetchPrompts();
  }

  Future<void> _fetchPrompts() async {
    final prompts = await getAllPrompts();
    setState(() {
      this.prompts = prompts;
    });
  }

  Future<void> _addPrompt(Prompt prompt) async {
    insertPrompt(prompt);
    _fetchPrompts();
  }

  Future<void> _updatePrompt(Prompt prompt) async {
    updatePrompt(prompt);
    _fetchPrompts();
  }
}

class PromptInfo extends StatefulWidget {
  final Prompt prompt;
  final TextEditingController titleController;
  final TextEditingController contentController;

  final VoidCallback deleteCallback;
  final VoidCallback updateCallback;

  const PromptInfo(
      {super.key,
      required this.prompt,
      required this.deleteCallback,
      required this.titleController,
      required this.contentController,
      required this.updateCallback});

  @override
  State<StatefulWidget> createState() => PromptInfoState();
}

class PromptInfoState extends State<PromptInfo> {
  late Prompt prompt;
  late TextEditingController titleController;
  late TextEditingController contentController;

  late VoidCallback deleteCallback;
  late VoidCallback updateCallback;

  @override
  void initState() {
    super.initState();
    prompt = widget.prompt;
    titleController = widget.titleController;
    contentController = widget.contentController;
    deleteCallback = widget.deleteCallback;
    updateCallback = widget.updateCallback;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD9D9D9),
            width: 0.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.library_books,
            color: Color(0xFF999999),
            size: 30,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              prompt.title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.normal, height: 2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: updatePrompt,
            child: const Icon(
              Icons.edit,
              color: Color(0xFF999999),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: deleteCallback,
            child: const Icon(
              Icons.delete,
              color: Color(0xFF999999),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  void updatePrompt(){
    titleController.text = prompt.title;
    contentController.text = prompt.content;
    updateCallback();
  }


}

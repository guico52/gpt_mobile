
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/widget/alertDialog.dart';

class Prompt {
  String id;
  String title;
  String content;

  Prompt({
    required this.id,
    required this.title,
    required this.content,
  });
}

class PromptPage extends StatefulWidget {
  const PromptPage({Key? key}) : super(key: key);

  @override
  PromptPageState createState() => PromptPageState();
}

class PromptPageState extends State<PromptPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  List<Prompt> prompts = [
    Prompt(id: '1', title: '1', content: '1'),
    Prompt(id: '2', title: '2', content: '2'),
  ];

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
          key: Key(prompts.length.toString()),
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            return PromptInfo(
              prompt: prompts[index],
              titleController: titleController,
              contentController: contentController,
              deletePrompt: () {
                setState(() {
                  prompts.removeAt(index);
                });
              },
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
                    prompts.add(Prompt(
                        id: Random().nextInt(100).toString(),
                        title: titleController.text,
                        content: contentController.text));
                  }),
                  Navigator.of(context).pop(),
                  titleController.clear(),
                  contentController.clear(),
                }));
  }

  void updatePrompt(){
    showDialog(context: context, builder: (context) => PromptAlertDialog(
        titleController: titleController, contentController: contentController,
        callBackFunction: () =>{
          setState(() {
            prompts.add(Prompt(id: Random().nextInt(100).toString(), title: titleController.text, content: contentController.text));
          }),
          Navigator.of(context).pop(),
          titleController.clear(),
          contentController.clear(),
        }));
  }
}

class PromptInfo extends StatefulWidget {
  final Prompt prompt;
  final TextEditingController titleController;
  final TextEditingController contentController;

  final VoidCallback deletePrompt;

  const PromptInfo({super.key,
    required this.prompt,
    required this.deletePrompt,
    required this.titleController,
    required this.contentController
  });

  @override
  State<StatefulWidget> createState() => PromptInfoState();
}

class PromptInfoState extends State<PromptInfo> {
  late Prompt prompt;
  late VoidCallback deletePrompt;
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    prompt = widget.prompt;
    deletePrompt = widget.deletePrompt;
    titleController = widget.titleController;
    contentController = widget.contentController;
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
            onTap: deletePrompt,
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
    showDialog(context: context, builder: (context) => PromptAlertDialog(
        titleController: titleController, contentController: contentController,
        callBackFunction: () =>{
          setState(() {
            prompt.title = titleController.text;
            prompt.content = contentController.text;
          }),
          Navigator.of(context).pop(),
          titleController.clear(),
          contentController.clear(),
        }));
  }

}

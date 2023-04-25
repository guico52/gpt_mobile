import 'package:flutter/material.dart';

class PromptAlertDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback updatePrompt;

  const PromptAlertDialog({
    Key ?key,
    required this.titleController,
    required this.contentController,
    required this.updatePrompt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '请输入prompt标题',
              ),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '内容',
                hintText: '请输入prompt内容',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      titleController.clear();
                      contentController.clear();
                    },
                    child: const Text("取消"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: updatePrompt,
                    child: const Text("更新"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

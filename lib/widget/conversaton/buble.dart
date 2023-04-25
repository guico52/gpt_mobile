/// 对话框
import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  final String text;
  final int role;
  final VoidCallback delete;

  const Bubble(
      {Key? key, required this.text, required this.role, required this.delete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BubbleState();
}

class BubbleState extends State<Bubble> {
  late int role; // 0：user 1：robot 2: system
  late String message;
  late bool isExpanded;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    role = widget.role;
    message = widget.text;
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(_getIconData(), // 根据role显示不同的图标
                    color: Colors.grey[700])),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      _getRoleString(),
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: editText, icon: const Icon(Icons.edit_note), color: Colors.grey[700],),
                        IconButton(onPressed: widget.delete, icon: const Icon(Icons.delete_forever_outlined), color: Colors.grey[700]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ]
                ),
            ),
          ],
        ),
    );
  }

  IconData _getIconData() {
    switch (role) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.chat_bubble_outline;
      case 2:
        return Icons.settings;
      default:
        return Icons.settings;
    }
  }

  String _getRoleString(){
    switch (role){
      case 0:
        return '用户';
      case 1:
        return '机器人';
      case 2:
        return '系统';
      default:
        return '系统';
    }
  }

  void editText(){
    setState(() {
      message = _controller.text;
      // TODO: 发送请求，修改数据库中的数据
    });
  }
}

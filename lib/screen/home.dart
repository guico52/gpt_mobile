import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/screen/home_views/chat.dart';
import 'package:ohmygpt_mobile/screen/home_views/conversation.dart';
import 'package:ohmygpt_mobile/screen/home_views/prompt.dart';
import 'package:ohmygpt_mobile/screen/home_views/setting.dart';

import '../route.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      routes: routes,
      home: const HomePage()
      );
  }
}



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Center(child: ConversationPage()),
    const Center(child: PromptPage()),
    const Center(child: Text('账单页面')),
    const Center(child: SettingsPage())
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航栏
        type: BottomNavigationBarType.fixed,
        // 选中的颜色
        selectedItemColor: Colors.black,
        // 未选中的颜色
        unselectedItemColor: Colors.grey,
        // 当前选中的索引
        currentIndex: _currentIndex,
        // 点击事件
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // 底部导航栏的items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '会话',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'prompt仓库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: '账单',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '系统设置',
          ),
        ],
      )
    );
  }
}
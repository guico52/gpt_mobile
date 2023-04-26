import 'package:flutter/material.dart';
import 'package:ohmygpt_mobile/screen/home.dart';
import 'package:ohmygpt_mobile/dao/dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据库
  await initDB();
  // 运行应用
  runApp(const Home());
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  late Color _themeColor;

  @override
  void initState(){
    super.initState();
    _loadThemeColor();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Home',
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: _themeColor,
      )
    );
  }

  Future<void> _loadThemeColor() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeColor = Color(prefs.getInt('themeColor') ?? 0x00000000);
    });
  }

}

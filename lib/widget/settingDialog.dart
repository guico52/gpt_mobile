import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<StatefulWidget> createState() => SettingDialogState();
}

class SettingDialogState extends State<SettingDialog> {
  String model = "gpt-3.5-turbo";
  double temp = 0.7;
  double top_P = 1;
  int n = 5;
  int maxTokens = 200;
  double presencePenalty = 0;
  double frequencyPenalty = 0;
  bool stream = false;

  Map<String, dynamic> get settingValues => {
        'model': model,
        'temperature': temp,
        'top_p': top_P,
        'n': n,
        'max_tokens': maxTokens,
        'presence_penalty': presencePenalty,
        'frequency_penalty': frequencyPenalty,
        'stream': stream,
      };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyDoubleSlider(
                  valueName: '温度',
                  value: temp,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          temp = value;
                        });
                      }),
              MyDoubleSlider(
                  valueName: '顶部概率',
                  value: top_P,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          top_P = value;
                        });
                      }),
              MyDoubleSlider(
                  valueName: '存在惩罚',
                  value: presencePenalty,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          presencePenalty = value;
                        });
                      }),
              MyDoubleSlider(
                  valueName: '频率惩罚',
                  value: frequencyPenalty,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          frequencyPenalty = value;
                        });
                      }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("流式生成回复"),
                  Switch(
                      value: stream,
                      onChanged: (value) {
                        setState(() {
                          stream = value;
                        });
                      }),
                ],
              ),


              MyIntegerInput(
                  valueName: '上下文数量',
                  value: n,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          n = value;
                        });
                      }),
              MyIntegerInput(
                  valueName: '最大消耗token',
                  value: maxTokens,
                  valueChangedCallback: () => (value) {
                        setState(() {
                          maxTokens = value;
                        });
                      }),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("取消"),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(settingValues);
                      },
                      child: const Text("确定"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDoubleSlider extends StatefulWidget {
  final String valueName;
  final double value;
  final VoidCallback valueChangedCallback;

  const MyDoubleSlider(
      {super.key,
      required this.valueName,
      required this.valueChangedCallback,
      required this.value});

  @override
  State<StatefulWidget> createState() => MyDoubleSliderState();
}

class MyDoubleSliderState extends State<MyDoubleSlider> {
  late double _currentValue;
  late String valueName;
  late VoidCallback valueChangedCallback;

  @override
  void initState() {
    super.initState();
    valueName = widget.valueName;
    valueChangedCallback = widget.valueChangedCallback;
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$valueName: $_currentValue'),
        CupertinoSlider(
          value: _currentValue,
          min: -2.0,
          max: 2.0,
          divisions: 40,
          onChanged: (double newValue) {
            _handleSliderValueChanged(newValue);
          },
        ),
      ],
    ));
  }

  void _handleSliderValueChanged(double newValue) {
    // newValue保留一位小数
    newValue = double.parse(newValue.toStringAsFixed(1));
    setState(() {
      _currentValue = newValue;
      valueChangedCallback;
    });
  }
}

class MyIntegerInput extends StatefulWidget {
  final String valueName;
  final VoidCallback valueChangedCallback;
  final int value;

  const MyIntegerInput(
      {super.key,
      required this.valueName,
      required this.valueChangedCallback,
      required this.value});

  @override
  State<StatefulWidget> createState() => MyIntegerInputState();
}

class MyIntegerInputState extends State<MyIntegerInput> {
  late int _currentValue;
  late String valueName;
  late VoidCallback valueChangedCallback;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    valueName = widget.valueName;
    valueChangedCallback = widget.valueChangedCallback;
    _currentValue = widget.value;
    _controller.text = _currentValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$valueName:'),
        TextField(
          keyboardType: TextInputType.number,
          controller: _controller,
          textAlign: TextAlign.center,
          onChanged: (String newValue) {
            _handleSliderValueChanged(int.parse(newValue));
          },
        ),
      ],
    ));
  }

  void _handleSliderValueChanged(int newValue) {
    setState(() {
      _currentValue = newValue.toInt();
    });
  }
}

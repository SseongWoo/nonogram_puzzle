import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyKeyboardListener extends StatefulWidget {
  final Widget? child;
  final Function(RawKeyEvent) onKeyEvent; // 콜백

  MyKeyboardListener({this.child, required this.onKeyEvent});

  @override
  _KeyboardListenerState createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<MyKeyboardListener> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    widget.onKeyEvent(event); // 콜백 호출
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}

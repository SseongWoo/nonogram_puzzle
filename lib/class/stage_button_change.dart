import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final double buttonSize;
  final IconData icon;
  final VoidCallback? onPressed; // 외부에서 전달받는 콜백 함수
  final double iconSize;

  const MyButton({super.key,
    required this.buttonSize,
    required this.icon,
    required this.onPressed,
    required this.iconSize
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (buttonSize / 2) - (buttonSize / 20),
      width: (buttonSize - (buttonSize / 20)) / 2,
      padding: EdgeInsets.all(buttonSize / 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.lightBlue,
          shape: const CircleBorder(),
        ),
        child: Icon(color: Colors.white, icon, size: iconSize, ),
      ),
    );
  }
}
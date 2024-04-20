import 'package:flutter/material.dart';

//원형 버튼을 만들기 위한 클래스
class ChoiceButton extends StatelessWidget {
  final double buttonSize;
  final IconData icon;
  final VoidCallback? onPressed; // 외부에서 전달받는 콜백 함수
  final double iconSize;

  const ChoiceButton({super.key,
    required this.buttonSize,
    required this.icon,
    required this.onPressed,
    required this.iconSize
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (buttonSize / 2) - (buttonSize / 20),
      width: (buttonSize - (buttonSize / 20)) / 2,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.lightBlue,
          shape: const CircleBorder(),
        ),
        child: Center(child: Icon(color: Colors.white, icon, size: iconSize, )),
      ),
    );
  }
}
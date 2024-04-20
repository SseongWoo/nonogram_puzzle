import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/main_menu.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginFailed = false;

  late double loginBoxHeight;
  late double loginBoxWidth;

  double _getLoginBoxHeightPER(int per){
    return (loginBoxHeight * per) / 100;
  }
  double _getLoginBoxWidthPER(int per){
    return (loginBoxWidth * per) / 100;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    loginBoxHeight = (screenSize.height * 40) / 100;
    loginBoxWidth = (screenSize.width * 50) / 100;
    return Scaffold(
      body: Center(
        child: Container(
          height: loginBoxHeight,
          width: loginBoxWidth,
          decoration: BoxDecoration(
              color: Colors.lightGreenAccent,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            children: [
              SizedBox(
                height: _getLoginBoxHeightPER(30),
                child: Center(
                  child: Text("Login",style: TextStyle(fontSize: _getLoginBoxHeightPER(10)),),
                ),
              ),
              SizedBox(
                height: _getLoginBoxHeightPER(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: _getLoginBoxWidthPER(70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color:
                                          _isLoginFailed ? Colors.red : Colors.black,
                                    ))),
                          ),
                          SizedBox(
                            height: _getLoginBoxHeightPER(3),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color:
                                          _isLoginFailed ? Colors.red : Colors.black,
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _getLoginBoxWidthPER(1),
                    ),
                    SizedBox(
                      height: _getLoginBoxHeightPER(30),
                      width: _getLoginBoxWidthPER(15),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          _isLoginFailed = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      ), child: const Icon(Icons.arrow_forward),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _getLoginBoxHeightPER(8),
                child: Row(
                  children: [
                    Container(
                      width: _getLoginBoxWidthPER(40),
                        alignment: Alignment.topCenter,
                        child: TextButton(onPressed: () {

                        }, child: Text("아이디, 비밀번호 찾기", style: TextStyle(color: Colors.black, fontSize: _getLoginBoxHeightPER(4)),))),
                    Container(
                      width: _getLoginBoxWidthPER(40),
                        alignment: Alignment.topCenter,
                        child: TextButton(onPressed: () {

                        }, child: Text("회원가입",style: TextStyle(color: Colors.black, fontSize: _getLoginBoxHeightPER(4),))),)
                  ],
                ),
              ),
              SizedBox(
                height: _getLoginBoxHeightPER(12),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, _getLoginBoxWidthPER(3), _getLoginBoxHeightPER(2)),
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainMenu()),
                          (route) => false,
                    );
                  }, child: RichText(
                    text: TextSpan(
                      text: '로그인 없이 접속하기 ',
                      style: TextStyle(color: Colors.black, fontSize: _getLoginBoxHeightPER(5)),
                      children: const [
                        WidgetSpan(
                          child: Icon(Icons.arrow_forward,color: Colors.black,),
                          alignment: PlaceholderAlignment.middle,
                        ),
                      ],
                    ),
                  )
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

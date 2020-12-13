import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/global_variables.dart';
import 'package:hifichat/screens/authentication/login.dart';
import 'package:hifichat/screens/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  bool isOnLoggin = true;

  @override
  void initState() {
    setState(() {
      isOnLoggin = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.white.withRed(170),
              ),
              Positioned(
                top: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: deviceWidth,
                  height: 100,
                  color: Colors.cyan,
                  child: Text(
                    'HiFi Chat',
                    textScaleFactor: 3,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: Container(
                  color: Colors.transparent,
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isOnLoggin = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isOnLoggin
                                    ? Colors.transparent
                                    : Colors.grey,
                                border: Border.all()),
                            padding: EdgeInsets.all(7),
                            child: Center(
                              child: Text(
                                'Login',
                                textScaleFactor: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isOnLoggin = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: !isOnLoggin
                                    ? Colors.transparent
                                    : Colors.grey,
                                border: Border.all()),
                            padding: EdgeInsets.all(7),
                            child: Center(
                              child: Text(
                                'Register',
                                textScaleFactor: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 170,
                left: 0,
                right: 0,
                child: Container(
                  child: AnimatedSizeAndFade.showHide(
                    vsync: this,
                    show: isOnLoggin,
                    child: LoginBox(),
                  ),
                ),
              ),
              Positioned(
                top: 170,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.white,
                  child: AnimatedSizeAndFade.showHide(
                    vsync: this,
                    show: !isOnLoggin,
                    child: RegisterBox(),
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

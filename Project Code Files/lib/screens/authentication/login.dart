import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/global_variables.dart';

class LoginBox extends StatefulWidget {
  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  final _regFormKey = GlobalKey<FormState>();

  String logPasswd, logEmail;
  bool loginStatus = false;
  var fireAuth = FirebaseAuth.instance;
  bool errorMsg = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _regFormKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email Can\'t be Empty';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      errorMsg = false;
                    },
                  );
                  logEmail = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Password';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      errorMsg = false;
                    },
                  );
                  logPasswd = value;
                },
              ),
            ),
            errorMsg
                ? Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email or Password is incorrect',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.start,
                    ),
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: !loginStatus
                  ? RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      color: Colors.lightBlueAccent,
                      splashColor: Colors.lightGreenAccent,
                      child: Text(
                        "Log In",
                        textScaleFactor: 2,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (_regFormKey.currentState.validate()) {
                          try {
                            setState(
                              () {
                                loginStatus = true;
                              },
                            );
                            var userLogin =
                                await fireAuth.signInWithEmailAndPassword(
                              email: logEmail,
                              password: logPasswd,
                            );
                            if (userLogin != null) {
                              email = logEmail;
                              username = (await hiFiFS
                                  .collection('/HiFiUsersData/')
                                  .doc(email)
                                  .get())['Username'];
                              Navigator.pushReplacementNamed(context, "/home");
                              setState(
                                () {
                                  loginStatus = false;
                                },
                              );
                            }
                          } catch (err) {
                            setState(
                              () {
                                errorMsg = true;
                                loginStatus = false;
                              },
                            );
                          }
                        }
                      },
                    )
                  : CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.green,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

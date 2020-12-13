import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/global_variables.dart';

class RegisterBox extends StatefulWidget {
  @override
  _RegisterBoxState createState() => _RegisterBoxState();
}

class _RegisterBoxState extends State<RegisterBox> {
  final _regFormKey = GlobalKey<FormState>();

  String regPasswd, regEmail, errorMsg = ' ';
  bool isError = false, regStatus = false;
  var fireAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _regFormKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Username';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Username",
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
                      username = value;
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
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
                    setState(() {
                      isError = false;
                    });
                    regEmail = value;
                  },
                ),
              ),
              isError
                  ? Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '$errorMsg',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : SizedBox(),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    } else if (value.length < 6) {
                      return 'Enter at least 6 Characters';
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
                    regPasswd = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: !regStatus
                    ? RaisedButton(
                        color: Colors.lightBlueAccent,
                        splashColor: Colors.lightGreenAccent,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          "Sign In",
                          textScaleFactor: 2,
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_regFormKey.currentState.validate()) {
                            try {
                              setState(() {
                                regStatus = true;
                              });

                              var userSignin =
                                  await fireAuth.createUserWithEmailAndPassword(
                                email: regEmail,
                                password: regPasswd,
                              );
                              if (userSignin.additionalUserInfo.isNewUser) {
                                email = regEmail;

                                hiFiFS
                                    .collection('/HiFiUsersData/')
                                    .doc(email)
                                    .set({
                                  'Username': username,
                                  'Email': email,
                                  'loc': [20.59, 78.96],
                                });
                                Navigator.pushReplacementNamed(
                                    context, "/home");
                                setState(() {
                                  regStatus = false;
                                });
                              }
                            } catch (err) {
                              var error = err.toString();
                              setState(() {
                                isError = true;
                                if (error.contains('already') &&
                                    error.contains('another')) {
                                  errorMsg = 'Email Already taken';
                                } else if (error.contains('badly') &&
                                    error.contains('formatted')) {
                                  errorMsg = 'Enter a valid Email';
                                }
                              });
                              setState(() {
                                regStatus = false;
                              });
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
      ),
    );
  }
}

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/global_variables.dart';
import 'package:hifichat/screens/location/usrlocn.dart';

var crntUname;
var crntchat;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _sendMsgField = TextEditingController();

  _buildMessage(String theMsg, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 7.0,
              bottom: 7.0,
              left: 111.0,
            )
          : EdgeInsets.only(
              top: 7.0,
              bottom: 7.0,
            ),
      padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
      width: deviceWidth * 0.75,
      color: isMe ? Colors.amber.withOpacity(0.77) : Colors.grey,
      child: Text(
        theMsg,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    var msgString;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
      ),
      padding: EdgeInsets.fromLTRB(21, 7, 7, 7),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              showCursor: true,
              maxLines: null,
              minLines: 1,
              autofocus: false,
              controller: _sendMsgField,
              onChanged: (value) {
                msgString = value;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            onPressed: () {
              if (_sendMsgField.text.isNotEmpty) {
                _sendMsgField.clear();
                hiFiFS.collection('/HiFiUsersData/$email/$crntchat/').add(
                  {
                    'isMe': true,
                    'msg': msgString,
                    'time': DateTime.now().toUtc(),
                  },
                ).then(
                  (value) {
                    hiFiFS
                        .collection('/HiFiUsersData/$crntchat/$email/')
                        .doc(value.id)
                        .set(
                      {
                        'isMe': false,
                        'msg': msgString,
                        'time': DateTime.now().toUtc(),
                      },
                    );
                    msgString = '';
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  //Dialog Box For Viewing Users Location
  Future locnDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen,
          contentPadding: EdgeInsets.all(10),
          title: Text('Users Location'),
          content: Container(
            height: deviceWidth * 0.77,
            width: deviceWidth * 0.77,
            child: UsersLocn(),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          '$crntUname',
          style: TextStyle(
            fontSize: 28.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.location_on,
                color: Colors.greenAccent,
                size: 28,
              ),
              onPressed: () async {
                var data = await hiFiFS
                    .collection('/HiFiUsersData/')
                    .doc(crntchat)
                    .get();
                usrlat = (data['loc'])[0];
                usrlon = (data['loc'])[1];
                locnDialog();
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 28,
              ),
              onPressed: () async {
                Navigator.pop(context);
                hiFiFS
                    .collection('/HiFiUsersData/$email/$crntchat/')
                    .get()
                    .then(
                  (snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  },
                );
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 7),
              child: StreamBuilder(
                stream: hiFiFS
                    .collection('/HiFiUsersData/$email/$crntchat/')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Chatting',
                            textScaleFactor: 2.1,
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.data.documents.length <= 0) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Chatting',
                            textScaleFactor: 2.1,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return new ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return _buildMessage(
                          '${ds.get('msg')}',
                          ds.get('isMe'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/global_variables.dart';
import 'package:hifichat/screens/chat/chatScreen.dart';
import 'package:hifichat/screens/location/mylocn.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String searchFor;

  @override
  void initState() {
    setState(() {
      searchFor = ' ';
    });
    super.initState();
  }

  var numOfUsersFound = 1.0;
  var srhBoxlnth;
  @override
  void setState(fn) {
    srhBoxlnth = numOfUsersFound;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: MyLocnMap(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'HiFi Chat',
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.lightBlueAccent.withOpacity(0.46),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  'Search For User and Start Chatting',
                  textScaleFactor: 1.1,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  border: Border.all(width: 1.5, color: Colors.blue),
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 7),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search by Username',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchFor = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      searchFor = value;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 60 * srhBoxlnth,
                child: StreamBuilder(
                  stream: hiFiFS
                      .collection('/HiFiUsersData/')
                      .where('Username', isEqualTo: '$searchFor')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(' ');
                    } else if (snapshot.data.documents.length <= 0) {
                      return Text(' ');
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot allUsrsData =
                              snapshot.data.documents[index];
                          numOfUsersFound =
                              snapshot.data.documents.length + 0.1;
                          return GestureDetector(
                            onTap: () {
                              crntchat = allUsrsData.get('Email');
                              crntUname = allUsrsData.get('Username');
                              Navigator.pushNamed(context, '/home/chat');
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(21, 7, 21, 7),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    allUsrsData.get('Username'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: deviceWidth * 0.45,
                                    height: 18,
                                    child: Text(
                                      '${allUsrsData.get('Email')}',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

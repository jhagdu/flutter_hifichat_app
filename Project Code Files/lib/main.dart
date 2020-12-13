import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hifichat/screens/authentication/auth_screen.dart';
import 'package:hifichat/screens/chat/chatScreen.dart';
import 'package:hifichat/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HiFiChat());
}

class HiFiChat extends StatefulWidget {
  @override
  _HiFiChatState createState() => _HiFiChatState();
}

class _HiFiChatState extends State<HiFiChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: { 
        '/': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/home/chat': (context) => ChatScreen(),
      },
    );
  }
}

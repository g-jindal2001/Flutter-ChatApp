import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  /*void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    
    FirebaseMessaging.onMessage.listen((event) {
      print('Got a message ')
    });
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic> ;
    final listenerId = data['listenerId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(listenerId),
            ),
            NewMessage(listenerId),
          ],
        ),
      ),
    );
  }
}

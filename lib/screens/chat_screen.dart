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
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final listenerId = data['listenerId'];
    final username = data['username'];
    final imageUrl = data['image_url'];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            Container(
              child: Text(username),
              margin: EdgeInsets.only(left: 10),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF0F0F0),
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

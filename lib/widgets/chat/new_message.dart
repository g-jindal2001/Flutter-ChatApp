import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../misc/attatchment_icons.dart';

class NewMessage extends StatefulWidget {
  final String listenerId;

  NewMessage(this.listenerId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage(String downloadURL, String name) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final creatorData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    try {
      if (downloadURL == 'NoDownLoadURL') {
        FirebaseFirestore.instance.collection('chat').add({
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'uniqueId': user.uid + widget.listenerId,
          'creatorId': user.uid,
          'creatorName': creatorData['username'],
          'creatorImage': creatorData['image_url'],
        });
      }

      if (downloadURL.contains('chat_docs')) {
        FirebaseFirestore.instance.collection('chat').add({
          'document': downloadURL,
          'createdAt': Timestamp.now(),
          'uniqueId': user.uid + widget.listenerId,
          'creatorId': user.uid,
          'creatorName': creatorData['username'],
          'creatorImage': creatorData['image_url'],
          'name': name,
        });
      } else {
        FirebaseFirestore.instance.collection('chat').add({
          'image': downloadURL,
          'createdAt': Timestamp.now(),
          'uniqueId': user.uid + widget.listenerId,
          'creatorId': user.uid,
          'creatorName': creatorData['username'],
          'creatorImage': creatorData['image_url'],
        });
      }
    } catch (error) {
      print(error);
    }
    _controller.clear();
  }

  void _getFile(File file, String typeOfFile, String name) async {
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
    if (file != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_${typeOfFile}s')
          .child(name);

      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      _sendMessage(url, name);
    } else {
      print("Error");
    }
  }

  void _showModalBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: GridView(
            children: [
              AttatchmentIcons('document', 'Document', _getFile),
              AttatchmentIcons('camera', 'Camera', _getFile),
              AttatchmentIcons('camera', 'Gallery', _getFile),
            ],
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              childAspectRatio: 1.75,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.only(left: 30, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () => _showModalBottomSheet(context),
            icon: Icon(Icons.attachment),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty
                ? null
                : () => _sendMessage('NoDownLoadURL', 'none'),
            icon: Icon(
              Icons.send,
            ),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

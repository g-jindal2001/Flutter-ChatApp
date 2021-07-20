import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String listenerId;

  Messages(this.listenerId);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      //StreamBuilder continously emits a stream of data from a source and whenver the source data changes, the streamSnapshot modifies itself accordingly
      stream: FirebaseFirestore.instance
          .collection('chat').where('participants', arrayContainsAny: [user.uid, listenerId])
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['userId'] == user.uid,
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
            key: ValueKey(chatDocs[index].id),// Assigning a unique key to each message(not compulsory) to optimize performance
          ),
        );
      },
    );
  }
}

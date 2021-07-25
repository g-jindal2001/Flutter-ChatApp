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
          .collection('chat')
          .where('uniqueId', whereIn: [
        user.uid + listenerId,
        listenerId + user.uid,
      ]) //whereIn in flutter is same as 'in' condition in Firebase
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
          itemBuilder: (ctx, index) {
            try {
              return MessageBubble(
                chatDocs[index]['text'],
                'none',
                'text',
                chatDocs[index]['creatorId'] == user.uid,
                chatDocs[index]['creatorName'],
                chatDocs[index]['creatorImage'],
                key: ValueKey(chatDocs[index]
                    .id), // Assigning a unique key to each message(not compulsory) to optimize performance
              );
            } catch (error) {
              try {
                return MessageBubble(
                  chatDocs[index]['image'],
                  'none',
                  'image',
                  chatDocs[index]['creatorId'] == user.uid,
                  chatDocs[index]['creatorName'],
                  chatDocs[index]['creatorImage'],
                  key: ValueKey(chatDocs[index]
                      .id), // Assigning a unique key to each message(not compulsory) to optimize performance
                );
              } catch (error) {
                return MessageBubble(
                  chatDocs[index]['document'],
                  chatDocs[index]['name'],
                  'document',
                  chatDocs[index]['creatorId'] == user.uid,
                  chatDocs[index]['creatorName'],
                  chatDocs[index]['creatorImage'],
                  key: ValueKey(chatDocs[index]
                      .id), // Assigning a unique key to each message(not compulsory) to optimize performance
                );
              }
            }
          },
        );
      },
    );
  }
}

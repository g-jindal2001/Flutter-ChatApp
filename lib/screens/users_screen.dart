import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './chat_screen.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance
                    .signOut(); //Firebase handles all signout operations including the token associated with it
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('email',
                isNotEqualTo: FirebaseAuth.instance.currentUser.email)
            .get(), //Use .get to get one-time access to the collections of users
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.data == null) {
            print('No users data');
            return CircularProgressIndicator();
          }

          final users = userSnapshot.data.docs;
          //final user = FirebaseAuth.instance.currentUser;

          return ListView.builder(
            itemBuilder: (ctx, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(users[index]['image_url']),
              ),
              title: Text(
                users[index]['username'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'This is the latest message!',
                style: TextStyle(color: Colors.grey[400]),
              ),
              onTap: () {
                //final listenerData = await FirebaseFirestore.instance.collection('users').doc(users[index].id).get();
                //final creatorData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

                Navigator.of(context).pushNamed(
                  ChatScreen.routeName,
                  arguments: {
                    //'creatorId': user.uid,
                    //'creatorImage': creatorData['image_url'],
                    //'creatorUsername': creatorData['username'],
                    'listenerId': users[index].id,
                    //'listenerImage': listenerData['image_url'],
                    //'listenerUsername': listenerData['username']
                  },
                ); 
              },
            ),
            itemCount: users.length,
          );
        },
      ),
    );
  }
}

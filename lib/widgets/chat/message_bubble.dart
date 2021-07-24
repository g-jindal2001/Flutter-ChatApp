import 'package:flutter/material.dart';

import '../misc/file_handler.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String name;
  final String type;
  final bool isMe;
  final String creatorName;
  final String creatorImage;
  final Key key;

  MessageBubble(this.message, this.name, this.type, this.isMe, this.creatorName,
      this.creatorImage,
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: !isMe ? Radius.circular(0) : Radius.circular(12),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    creatorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                  ),
                  if (message.startsWith(
                      'https://firebasestorage.googleapis.com/v0/b/flutter-chat-7e9d3.appspot.com/o/'))
                    if (message.contains('chat_images'))
                      Container(
                        child: Image.network(
                          message,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          frameBuilder: (BuildContext context, Widget child,
                              int frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              child: child,
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                  if (message.contains('chat_docs')) FileHandler(name, message),
                  if (!message.startsWith(
                      'https://firebasestorage.googleapis.com/v0/b/flutter-chat-7e9d3.appspot.com/o/'))
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1.color,
                      ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          //Positioned Widget is mainly used to position child widgets of a Stack properly
          child: CircleAvatar(
            backgroundImage: NetworkImage(creatorImage),
          ),
          top: -5,
          right: isMe ? 120 : null,
          left: isMe ? null : 120,
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String creatorName;
  final String creatorImage;
  final Key key;

  MessageBubble(this.message, this.isMe, this.creatorName, this.creatorImage,
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
                  if (message.startsWith('https'))
                    Container(
                      child: Image.network(
                        message,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (!message.startsWith('https'))
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

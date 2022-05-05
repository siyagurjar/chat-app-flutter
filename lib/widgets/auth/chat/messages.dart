import 'dart:html';

import 'package:chat_shiva/widgets/auth/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futuresnapshot) {
        if (futuresnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              ;
              return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data.document.length,
                itemBuilder: (context, index) => MessageBubble(
                  chatSnapshot.data.document[index]['text'],
                  chatSnapshot.data.document[index]['userName'],
                  chatSnapshot.data.document[index]['userImage'],
                  chatSnapshot.data.document[index]['userId'] ==
                      futuresnapshot.data.uid,
                  key: ValueKey(chatSnapshot.data.document[index].documentID),
                ),
              );
            });
      },
    );
  }
}

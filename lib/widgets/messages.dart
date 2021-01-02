import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ATENÇÃO: Nova versão!
    final User user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            // ATENÇÃO: Nova versão!
            chatDocs[i].get('text'),
            chatDocs[i].get('userName'),
            chatDocs[i].get('userImage'),
            chatDocs[i].get('userId') == user.uid,

            // ATENÇÃO: Versão antiga!
            // chatDocs[i]['text'],
            // chatDocs[i]['userName'],
            // chatDocs[i]['userImage'],
            // chatDocs[i]['userId'] == user.uid,
            key: ValueKey(chatDocs[i].documentID),
          ),
        );
      },
    );

    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser(),
    //   builder: (ctx, userSnapshot) {
    //     if (userSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }

    //     return StreamBuilder(
    //       stream: Firestore.instance
    //           .collection('chat')
    //           .orderBy('createdAt', descending: true)
    //           .snapshots(),
    //       builder: (ctx, chatSnapshot) {
    //         if (chatSnapshot.connectionState == ConnectionState.waiting) {
    //           return Center(child: CircularProgressIndicator());
    //         }

    //         final chatDocs = chatSnapshot.data.documents;
    //         return ListView.builder(
    //           reverse: true,
    //           itemCount: chatDocs.length,
    //           itemBuilder: (ctx, i) => MessageBubble(
    //             chatDocs[i]['text'],
    //             chatDocs[i]['userName'],
    //             chatDocs[i]['userImage'],
    //             chatDocs[i]['userId'] == userSnapshot.data.uid,
    //             key: ValueKey(chatDocs[i].documentID),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }
}

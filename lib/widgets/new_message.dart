import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    // ATENÇÃO: Nova versão!
    final user = FirebaseAuth.instance.currentUser;

    // ATENÇÃO: Versão antiga!
    // final user = await FirebaseAuth.instance.currentUser();

    // ATENÇÃO: Nova versão!
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // ATENÇÃO: Versão antiga!
    // final userData = await Firestore.instance
    //   .collection('users')
    //   .document(user.uid)
    //   .get();

    // ATENÇÃO: Nova versão!
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.get('name'),
      'userImage': userData.get('imageUrl'),
    });

    // ATENÇÃO: Versão antiga!
    // Firestore.instance.collection('chat').add({
    //   'text': _enteredMessage,
    //   'createdAt': Timestamp.now(),
    //   'userId': user.uid,
    //   'userName': userData['name'],
    //   'userImage': userData['imageUrl'],
    // });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autocorrect: true,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enviar mensagem...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}

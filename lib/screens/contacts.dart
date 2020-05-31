import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/models/contacts.dart';
import 'package:video_chat/models/message.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/services/firestore.dart';

import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/widgets/avatar.dart';
import 'package:video_chat/widgets/chat_tile.dart';

import 'chatScreen.dart';

class Contacts extends StatelessWidget {
  final Contact contact;
  final String uid;
  // final AuthMethods _authMethods = AuthMethods();

  Contacts(this.contact, this.uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
            uid: this.uid
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<User> getUserDetailsById(id) async {
    try{
      DocumentSnapshot documentSnapshot = await Firestore.instance.collection('userData').document(id).get();
      print(documentSnapshot['username']);
      return User.fromMap(documentSnapshot.data);
    } catch(e){
      print(e);
      return null;
    }
  }
}

class ViewLayout extends StatelessWidget {
  final String uid;
  final User contact;
  // final ChatMethods _chatMethods = ChatMethods();
  final DbCalls dbCalls = DbCalls();

  ViewLayout({
    @required this.contact, this.uid,
  });

  @override
  Widget build(BuildContext context) {

    return ChatTile(
      small: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        contact.username,
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: dbCalls.fetchLastMessageBetween(
          senderId: this.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(contact.profilePhoto),
              radius: 80,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          }

          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}

enum UserState{
  Offline,
  Online,
  Waiting,
}

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  // final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('userData').document(uid).snapshots(),
        builder: (context, snapshot) {
          User user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = User.fromMap(snapshot.data.data);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}

 UserState numToState(int number) {
     switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }
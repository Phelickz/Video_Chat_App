import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_chat/models/message.dart';
import 'package:video_chat/models/user.dart';

Firestore _firestore = Firestore.instance;

class DbCalls {
  DbCalls dbCalls;

  Future<List<User>> getAllUsers(String uid) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await _firestore.collection("userData").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> sendMessage(Message message, User sender, User receiver) async {
    var map = message.toMap();
    await _firestore
        .collection('messages')
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);
    
   return await _firestore
        .collection('messages')
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> getMessagesSnapshots(context, String _userId, String _receiverId) async* {
    yield* _firestore
        .collection('messages')
        .document(_userId)
        .collection(_receiverId)
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}

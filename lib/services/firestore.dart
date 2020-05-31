import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/models/contacts.dart';
import 'package:video_chat/models/message.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/state/imageProvider.dart';
import 'package:video_chat/state/userState.dart';

Firestore _firestore = Firestore.instance;
FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
StorageReference _storageReference;

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
    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _firestore
        .collection('messages')
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContacts({String of, String forContact}) => _firestore
      .collection('userData')
      .document(of)
      .collection('contacts')
      .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToReceiveerContact(senderId, receiverId, currentTime);
    await addToSenderContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot sender =
        await getContacts(of: senderId, forContact: receiverId).get();
    if (!sender.exists) {
      Contact receiver = Contact(uid: receiverId, timestamp: currentTime);

      var receiverMap = receiver.toMap(receiver);

      await getContacts(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiveerContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiver =
        await getContacts(of: receiverId, forContact: senderId).get();
    if (!receiver.exists) {
      Contact sender = Contact(uid: senderId, timestamp: currentTime);

      var senderMap = sender.toMap(sender);

      await getContacts(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> getMessagesSnapshots(
      context, String _userId, String _receiverId) async* {
    yield* _firestore
        .collection('messages')
        .document(_userId)
        .collection(_receiverId)
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<String> uploadImageStorage(File image) async {
    try {
      _storageReference = _firebaseStorage
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageServiceProvider _imageServiceProvider) async {
    _imageServiceProvider.setToLoading();

    String url = await uploadImageStorage(image);

    _imageServiceProvider.setToIdle();

    imageMsg(url, receiverId, senderId);
  }

  void imageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
        message: "Image",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');
    var map = _message.toImageMap();

    await _firestore
        .collection('messages')
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _firestore
        .collection('messages')
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _firestore
      .collection('userData')
      .document(userId)
      .collection('contacts')
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _firestore
          .collection('messages')
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  getUsersData(UserNotifier userNotifier, String uid) async {
    QuerySnapshot snapshot = await _firestore
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    List<User> _usersList = [];

    snapshot.documents.forEach((document) async {
      User user = User.fromMap(document.data);
      _usersList.add(user);
    });

    userNotifier.userProfileData = _usersList;
  }
}


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/models/calls.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/screens/calls/call.dart';

class CallService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream({String uid}) =>
      _collectionReference.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.dialler = true;
      Map<String, dynamic> diallerMap = call.toMap(call);

      call.dialler = false;
      Map<String, dynamic> receiverMap = call.toMap(call);

      await _collectionReference.document(call.callerID).setData(diallerMap);
      await _collectionReference.document(call.receiverID).setData(receiverMap);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await _collectionReference.document(call.callerID).delete();
      await _collectionReference.document(call.receiverID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  dial({User dialler, User receiver, context}) async {
    Call call = Call(
      callerID: dialler.uid,
      callerName: dialler.username,
      callerPic: dialler.profilePhoto,
      receiverID: receiver.uid,
      receiverName: receiver.username,
      receiverPic: receiver.profilePhoto,
      channelID: Random().nextInt(10000).toString(),
    );

    bool callMade = await makeCall(call: call);

    call.dialler = true;
    if (callMade) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}

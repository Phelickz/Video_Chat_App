import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp timestamp;

  Contact({this.uid, this.timestamp});

  Map toMap (Contact contact) {
    var data = Map<String, dynamic>();
    data['contactID'] = contact.uid;
    data['createdAt'] = contact.timestamp;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> data){
    this.uid = data['contactID'];
    this.timestamp = data['createdAt'];
  }
}
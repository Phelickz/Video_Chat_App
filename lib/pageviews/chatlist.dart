import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/models/contacts.dart';
import 'package:video_chat/screens/contacts.dart';
import 'package:video_chat/screens/search.dart';
import 'package:video_chat/services/firestore.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/widgets/appbar.dart';
import 'package:video_chat/widgets/avatar.dart';
import 'package:video_chat/widgets/chat_tile.dart';



class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          backgroundColor: Colors.blue,
          onPressed: null),
      backgroundColor: GlobalColors.blackColor,
      appBar: _customAppBar(context),
      body: Chats(),
    );
  }

  CustomAppBar _customAppBar(BuildContext context) {
    return CustomAppBar(
      title: Avatar(),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
      centerTitle: true,
    );
  }
}

final DbCalls dbCalls = DbCalls();

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  String uid;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) async { 
      String uid = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();
      setState(() {
        this.uid = uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: dbCalls.fetchContacts(
            userId: this.uid
          ),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              var data = snapshot.data.documents;

              if(data.isEmpty){
                return Center(child: Text('Start a new conversation', style: TextStyle(
                  color: Colors.white54
                ),));
              }

              return ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {

                  Contact contact = Contact.fromMap(data[index].data);
                  return Contacts(
                    contact, uid
                  );
                });
            }
              return Center(child: CircularProgressIndicator());
          }
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/models/message.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/services/firestore.dart';
import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/widgets/appbar.dart';
import 'package:video_chat/widgets/modeTlle.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  const ChatScreen({Key key, this.receiver}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Firestore _firestore = Firestore.instance;
  bool _writing = false;
  User sender;
  String _userId;

  DbCalls _dbCalls = DbCalls();

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _userId = user.uid;
        sender = User(
            uid: user.uid,
            username: user.displayName,
            profilePhoto: user.photoUrl);
      });
    });
  }

  TextEditingController _textEditingController = TextEditingController();

  isWriting(bool val) {
    setState(() {
      _writing = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      appBar: _appBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: _listMessages(),
          ),
          _chatTextField(),
        ],
      ),
    );
  }

  _sendMessage() {
    var _text = _textEditingController.text;

    Message _message = Message(
      receiverId: this.widget.receiver.uid,
      senderId: sender.uid,
      timestamp: Timestamp.now(),
      type: 'text',
      message: _text,
    );

    setState(() {
      _writing = false;
    });

    _dbCalls.sendMessage(_message, sender, this.widget.receiver);
    _textEditingController.clear();
  }

  Widget _listMessages() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: _dbCalls.getMessagesSnapshots(
              context, _userId, this.widget.receiver.uid),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? snapshot.data.documents.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return _chatMessageBubble(
                              snapshot.data.documents[index]);
                        })
                    : Center(
                        child: Text(
                        'Start a conversation',
                        style: TextStyle(color: Colors.white54),
                      ))
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _chatMessageBubble(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _userId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _userId
            ? _senderBubble(_message)
            : _receiverBubble(_message),
      ),
    );
  }

  Widget _senderBubble(Message _message) {
    return Container(
      // alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: 12, right: 2),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: GlobalColors.senderColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          _message.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _receiverBubble(Message _message) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: GlobalColors.senderColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          _message.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _chatTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => _showBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: GlobalColors.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              style: TextStyle(color: Colors.white),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? isWriting(true)
                    : isWriting(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: GlobalColors.greyColor),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: GlobalColors.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face),
                ),
              ),
            ),
          ),
          _writing
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          _writing ? Container() : Icon(Icons.camera),
          _writing
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    gradient: GlobalColors.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () => _sendMessage()),
                )
              : Container(),
        ],
      ),
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      title: Text(this.widget.receiver.username),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
    );
  }

  _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: GlobalColors.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contents",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                  child: ListView(
                children: <Widget>[
                  Tile(
                    title: "Media",
                    subtitle: "Share photos and videos",
                    icon: Icons.image,
                  ),
                  SizedBox(height: 5),
                  Tile(
                    title: "File",
                    subtitle: "Share files",
                    icon: Icons.file_upload,
                  ),
                  SizedBox(height: 5),
                  Tile(
                    title: "Contact",
                    subtitle: "Share contacrs",
                    icon: Icons.contacts,
                  ),
                  SizedBox(height: 5),
                  Tile(
                    title: "Location",
                    subtitle: "Share location",
                    icon: Icons.location_on,
                  ),
                ],
              ))
            ],
          );
        });
  }
}

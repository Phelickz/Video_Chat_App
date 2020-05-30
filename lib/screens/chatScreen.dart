import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_chat/models/message.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/services/firestore.dart';
import 'package:video_chat/services/uploadImage.dart';
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
  bool _writing = false;
  bool _showEmoji = false;
  User sender;
  ScrollController _scrollController = ScrollController();
  String _userId;

  DbCalls _dbCalls = DbCalls();

  FocusNode _focusNode = FocusNode();

  ImageService _imageService = ImageService();

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

  _showKeyboard() => _focusNode.requestFocus();

  _hideKeyboard() => _focusNode.unfocus();

  _hideEmojiContainer() {
    setState(() {
      _showEmoji = false;
    });
  }

  _showEmojiContainer() {
    setState(() {
      _showEmoji = true;
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
          _showEmoji
              ? Container(
                  child: _emojiContainer(),
                )
              : Container()
        ],
      ),
    );
  }

  _emojiContainer() {
    return EmojiPicker(
      bgColor: GlobalColors.separatorColor,
      indicatorColor: GlobalColors.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          _writing = true;
        });

        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            });
            return snapshot.hasData
                ? snapshot.data.documents.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        // reverse: true
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
            child: Stack(children: <Widget>[
              TextField(
                onTap: () => _hideEmojiContainer(),
                focusNode: _focusNode,
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
                ),
              ),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (!_showEmoji) {
                    _hideKeyboard();
                    _showEmojiContainer();
                  } else {
                    _showKeyboard();
                    _hideEmojiContainer();
                  }
                },
                icon: Icon(Icons.face),
              ),
            ]),
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

  _pickImage({@required ImageSource source}) async {
    File _selectedImage = await _imageService.pickImage(source: source);
  }
}

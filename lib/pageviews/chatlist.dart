import 'package:flutter/material.dart';
import 'package:video_chat/screens/search.dart';
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

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: 2,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return ChatTile(
                onTap: () {},
                small: false,
                leading: Avatar(),
                title: Text(
                  'Phelickz',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Arial",
                    fontSize: 19,
                  ),
                ),
                subtitle: Text(
                  'Hello',
                  style: TextStyle(
                    color: GlobalColors.greyColor,
                    fontSize: 14,
                  ),
                ),
              );
            }));
  }
}

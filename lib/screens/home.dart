import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/pageviews/callLogs.dart';
import 'package:video_chat/pageviews/chatlist.dart';
import 'package:video_chat/pageviews/contact.dart';
import 'package:video_chat/utils/colors.dart';

import 'calls/pickupLayout.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void _bottomTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        backgroundColor: GlobalColors.blackColor,
        body: PageView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: <Widget>[
            Container(child: ChatList()),
            Container(child: CallLogs()),
            Container(child: Contact())
          ],
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              onTap: _bottomTapped,
              currentIndex: _page,
              backgroundColor: GlobalColors.blackColor,
              items: <BottomNavigationBarItem>[
                _bottomNavigationBarItem("Chats", 0),
                _bottomNavigationBarItem("Calls", 1),
                _bottomNavigationBarItem("Contact", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String label, int number) {
    return BottomNavigationBarItem(
      icon: Icon(
        number == 0 ? Icons.chat : number == 1 ? Icons.call : Icons.contacts,
        color: _page == number
            ? GlobalColors.lightBlueColor
            : GlobalColors.greyColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: _page == number
              ? GlobalColors.lightBlueColor
              : GlobalColors.greyColor,
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/pageviews/callLogs.dart';
import 'package:video_chat/pageviews/chatlist.dart';
import 'package:video_chat/pageviews/contact.dart';
import 'package:video_chat/screens/contacts.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/utils/colors.dart';

import 'calls/pickupLayout.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  PageController _pageController;
  int _page = 0;

  int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }
  String uid;

  @override
  void initState() {

     SchedulerBinding.instance.addPostFrameCallback((_) async {
       final uid = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();
     setState(() {
       this.uid = uid;
     });
      setUserState(
        uid,
        UserState.Online, 
      );
    });

    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        this.uid != null
            ? setUserState(
                this.uid, UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        this.uid != null
            ? setUserState(
                this.uid, UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        this.uid != null
            ? setUserState(
                this.uid, UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        this.uid != null
            ? setUserState(
                this.uid, UserState.Offline)
            : print("detached state");
        break;
    }
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
            Container(child: Profile())
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

  void setUserState(String userId, UserState userstate){
    int stateNum = stateToNum(userstate);

    Firestore.instance.collection('userData').document(userId).updateData({
      "state" : stateNum
    });
  }
}

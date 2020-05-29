import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/screens/home.dart';
import 'package:video_chat/screens/login.dart';

import 'authState.dart';

void gotoHomeScreen(BuildContext context) {
  //  print(user['kUID']);
  Future.microtask(() {
    // var user = Provider.of<AuthenticationState>(context, listen: false).exposeUser();
    if (Provider.of<AuthenticationState>(context, listen: false).authStatus ==
        kAuthSuccess) {
      // var user = Provider.of<AuthenticationState>(context, listen: false).exposeUser();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  });
}

void gotoLoginScreen(BuildContext context) {
  Future.microtask(() {
    if (Provider.of<AuthenticationState>(context, listen: false).authStatus ==
        null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  });
}

// gotoProfileScreen(BuildContext context) async {
//   await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
// }

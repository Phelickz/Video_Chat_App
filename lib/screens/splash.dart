import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_chat/screens/home.dart';
import 'package:video_chat/screens/login.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/utils/colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Provider.of<AuthenticationState>(context, listen: false)
          .currentUser()
          .then((currentUser) => {
                if (currentUser == null)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()))
                  }
                else
                  {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()))
                        .catchError((e) => print(e))
                  }
              })
          .catchError((e) => print(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      body: Center(
          child: Shimmer(
        gradient: GlobalColors.fabGradient,
        child: Text(
          'CONNECT',
          style: TextStyle(
              // color: Colors.red[800],
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/screens/chatScreen.dart';
import 'package:video_chat/state/userState.dart';

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/search.dart';
import 'screens/splash.dart';
import 'state/authState.dart';
import 'state/imageProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationState()),
        ChangeNotifierProvider(create: (_) => ImageServiceProvider()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),

      ],
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}

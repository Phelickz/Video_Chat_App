import 'package:flutter/material.dart';
import 'package:video_chat/utils/colors.dart';

class CallLogs extends StatefulWidget {
  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      body: Center(child: Text('Call Logs')),
      
    );
  }
}
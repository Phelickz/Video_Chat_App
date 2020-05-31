import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/models/calls.dart';
import 'package:video_chat/screens/calls/pickup.dart';
import 'package:video_chat/services/callService.dart';
import 'package:video_chat/state/authState.dart';

class PickUpLayout extends StatefulWidget {
  final Widget scaffold;


  PickUpLayout({Key key, @required this.scaffold}) : super(key: key);

  @override
  _PickUpLayoutState createState() => _PickUpLayoutState();
}

class _PickUpLayoutState extends State<PickUpLayout> {
  String uid;

  CallService callService = CallService();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async { 
      final uid = await Provider.of<AuthenticationState>(context, listen: false)
        .currentUserId();
      setState(() {
        this.uid = uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return uid != null
        ? StreamBuilder<DocumentSnapshot>(
            stream: callService.callStream(uid: uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);

                if (!call.dialler) {
                  return PickUp(call: call);
                }

                return widget.scaffold;
              }
              return widget.scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:video_chat/models/calls.dart';
import 'package:video_chat/services/callService.dart';
import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/utils/permissions.dart';

import 'call.dart';

class PickUp extends StatelessWidget {
  final Call call;

  final CallService callService = CallService();

  PickUp({Key key, @required this.call}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                image: DecorationImage(image: 
                NetworkImage(call.callerPic))),
          ),
          Opacity(
            opacity: 0.9,
            child: Container(
              width: width,
              height: height,
              color: Colors.black,
            ),
          ),
          Positioned(
            top: height * 0.16,
            left: width * 0.28,
            child: Text('Incoming Call..', style: TextStyle(
              fontSize: 30,
              color: Colors.white,

              fontWeight: FontWeight.bold
            ),)),
          Positioned(
            top: height * 0.26,
            left: width * 0.27,
            child: Center(
              child: Text(call.callerName, style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
            )),
          Positioned(
             top: height * 0.76,
            left: width * 0.27,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "btn1",
                    backgroundColor: Colors.red,
                    child: Icon(Icons.call_end),
                    onPressed: () {
                      callService.endCall(call: call);
                    }),
                SizedBox(
                  width: 100,
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: Colors.green,
                  child: Icon(Icons.call),
                  onPressed: () async {
                    await Permissions().cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: this.call)))
                        : null;
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

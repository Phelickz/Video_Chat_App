import 'package:flutter/material.dart';
import 'package:video_chat/utils/colors.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: GlobalColors.userCircleBackground,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'AG',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: GlobalColors.lightBlueColor
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,

            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: GlobalColors.blackColor,
                  width: 2
                ),
                color: GlobalColors.onlineDotColor
              ),
            ),)
        ],
      ),
    );
  }
}

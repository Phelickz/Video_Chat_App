import 'package:flutter/material.dart';
import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/widgets/chat_tile.dart';

class Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const Tile({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ChatTile(
        leading: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: GlobalColors.receiverColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: GlobalColors.greyColor,
            size: 38,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: GlobalColors.greyColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

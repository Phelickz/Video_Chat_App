import 'package:flutter/material.dart';
import 'package:video_chat/utils/colors.dart';

class ChatTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool small;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const ChatTile({
    Key key,
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.small = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: small ? 10 : 0,
        ),
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: small ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: small ? 3 : 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0, color: GlobalColors.separatorColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),
                            subtitle,
                          ],
                        )
                      ],
                    ),
                    trailing ?? Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

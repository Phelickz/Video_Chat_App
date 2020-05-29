import 'package:flutter/material.dart';
import 'package:video_chat/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: GlobalColors.blackColor,
        border: Border(
          bottom: BorderSide(
            color: GlobalColors.separatorColor,
            width: 0.4,
            style: BorderStyle.solid,
          ),
         ),
      ),
      child: AppBar(
        backgroundColor: GlobalColors.blackColor,
        elevation: 0,
        leading: leading,
        title: title,
        actions: actions,
        centerTitle: centerTitle,
      ),
    );
  }

  // @override
  // // TODO: implement preferredSize
  // Size get preferredSize => throw UnimplementedError();

  final Size preferredSize = const Size.fromHeight(kToolbarHeight +10);
}

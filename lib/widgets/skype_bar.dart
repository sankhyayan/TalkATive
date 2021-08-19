import 'package:flutter/material.dart';
import 'package:skype_clone/widgets/appBar.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double defaultSize;
  final dynamic title;
  final List<Widget>actions;
  SkypeAppBar({required this.defaultSize, required this.title,required this.actions});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
        title: title is String
            ? Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : title,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        actions: actions ,
        centerTitle: true,
        defaultSize: defaultSize,
        color: Colors.black);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

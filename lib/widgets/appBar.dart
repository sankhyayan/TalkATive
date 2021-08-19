import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget title,leading;
  final List<Widget>actions;
  final bool centerTitle;
  final double defaultSize;
  final Color color;
  CustomAppBar({required this.title,required this.leading, required this.actions,required this.centerTitle,required this.defaultSize,required this.color});
   @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultSize),
      decoration: BoxDecoration(
        color: color,
        border: Border(
          bottom: BorderSide(
            color: Color(0xff272c35),
            style: BorderStyle.none,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: color,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }
  final Size preferredSize=const Size.fromHeight(kToolbarHeight+10);
}

import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget leading, title, icon, subtitle, trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final double defaultSize;
  CustomTile(
      {required this.leading,
      required this.title,
      required this.icon,
      required this.subtitle,
      required this.trailing,
      this.margin = const EdgeInsets.all(0),
      this.mini = true,
      required this.onTap,
      required this.onLongPress,
      required this.defaultSize});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mini ? defaultSize : 0,
        ),
        margin: margin,
        child: Row(
          children: [
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: mini ? defaultSize : defaultSize * 1.5),
                padding: EdgeInsets.symmetric(
                    vertical: mini ? defaultSize * .3 : defaultSize * 2),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      style: BorderStyle.none,
                      color: Color(0xff272c35),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        SizedBox(
                          height: defaultSize * .5,
                        ),
                        Container(
                          child: Row(
                            children: [
                              icon,
                              subtitle,
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: defaultSize,),
                    trailing,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

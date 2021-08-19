import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'customTile.dart';

//MODAL TILE + ICON STATELESS WIDGET
class ModalTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final double defaultSize;
  final GestureTapCallback onTap;
  ModalTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.defaultSize,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
      child: CustomTile(
        leading: Container(
          margin: EdgeInsets.only(right: defaultSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultSize * 1.5),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(defaultSize),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: defaultSize * 3.8,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: defaultSize * 1.8,
          ),
        ),
        icon: Container(),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: defaultSize * 1.4,
          ),
        ),
        trailing: Container(),
        onTap: onTap,
        onLongPress: () {},
        defaultSize: defaultSize,
        mini: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';
class NewChatButton extends StatelessWidget {
  final double defaultSize;
  NewChatButton({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: defaultSize * 2.5,
      ),
      padding: EdgeInsets.all(defaultSize*1.5),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final double defaultSize;
  final CallMethods callMethods = CallMethods();
  PickupLayout({required this.scaffold,required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return userProvider.getUser.uid != ""
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid!),
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data!.data()!=null){
                Call call=Call.fromMap(snapshot.data!.data() as Map<String,dynamic>);
                if(!call.hasDialled){///MAIN LOGIC-IF DIALLED THEN SHOW SCAFFOLD ELSE SHOW PICKUP SCREEN
                  return PickupScreen(call: call, defaultSize: defaultSize);
                }
                return scaffold;
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
  }
}

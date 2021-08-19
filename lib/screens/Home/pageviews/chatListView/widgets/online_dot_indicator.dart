import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/enum/userstate.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final double defaultSize;
  final String uid;
  final AuthMethods _authMethods = AuthMethods();
  OnlineDotIndicator({required this.defaultSize, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserOnlineOffline(uid: uid),
        builder: (context, snapshot) {
          UserData userData=UserData(uid: "", name: "", email: "", username: "", status: "", state: 0, profilePhoto: "");
          if(snapshot.hasData && snapshot.data!.data()!=null){
            userData=UserData.fromMap(snapshot.data!.data() as Map<String,dynamic>);
          }
          return Container(
            height: defaultSize*1.4,
            width: defaultSize*1.4,
            margin: EdgeInsets.only(right: defaultSize*.07,bottom: defaultSize*.45),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: defaultSize*.22),
              shape: BoxShape.circle,
              color: getColor(userData.state),
            ),
          );
        });
  }

  getColor(int state) {
    switch(Utils.numToState(state)){
      case UserState.Offline:
        return Colors.red;
      case UserState.Online:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

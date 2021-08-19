import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/callScreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial({required UserData from, required UserData to, context}) async {
    Call call = Call(
      callerId: from.uid!,
      callerName: from.name!,
      callerPic: from.profilePhoto!,
      receiverId: to.uid!,
      receiverName: to.name!,
      receiverPic: to.profilePhoto!,
      channelId: Random().nextInt(1000).toString(),
      hasDialled: false,
    );
    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;
    if (callMade) {
      //adds call logs to db
      await LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}

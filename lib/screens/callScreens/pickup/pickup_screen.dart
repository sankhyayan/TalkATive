import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/callScreens/call_screen.dart';
import 'package:skype_clone/screens/chatScreen/widgets/cached_image.dart';
import 'package:skype_clone/utils/permissions.dart';

class PickupScreen extends StatefulWidget {
  final Call call;
  final double defaultSize;
  PickupScreen({required this.call, required this.defaultSize});
  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCalledMissed=true;
  ///initialize and add logs to db(here call status = dialled/received/missed)
  addToLocalStorage({required String callStatus}) async{
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );
    ///adds data to db
    await LogRepository.addLogs(log);
  }
  @override
  void dispose() async{
    super.dispose();
    if(isCalledMissed){
      await addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: widget.defaultSize * 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: widget.defaultSize * 3,
              ),
            ),
            SizedBox(
              height: widget.defaultSize * 5,
            ),
            CachedImage(
              imageUrl: widget.call.callerPic!,
              radius: 180,
              isRound: true,
            ),
            SizedBox(
              height: widget.defaultSize * 1.5,
            ),
            Text(
              widget.call.callerName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: widget.defaultSize * 2,
              ),
            ),
            SizedBox(
              height: widget.defaultSize * 7.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    isCalledMissed=false;
                    await addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: widget.defaultSize * 2.5,
                ),
                IconButton(
                  onPressed: () async {
                    isCalledMissed=false;
                    await addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CallScreen(call: widget.call),
                            ),
                          )
                        : Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

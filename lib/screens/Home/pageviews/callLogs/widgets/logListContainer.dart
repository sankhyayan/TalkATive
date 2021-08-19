import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/quiet_box.dart';
import 'package:skype_clone/screens/chatScreen/widgets/cached_image.dart';
import 'package:skype_clone/utils/utilities.dart';
import 'package:skype_clone/widgets/customTile.dart';

class LogListContainer extends StatefulWidget {
  final double defaultSize;
  LogListContainer({required this.defaultSize});

  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon = Icon(
      Icons.call_received,
      color: Colors.green,
      size: widget.defaultSize * 1.5,
    );
    double _iconSize = widget.defaultSize * 1.5;
    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;
      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;
      default:
        _icon = Icon(
          Icons.call_received,
          color: Colors.grey,
          size: _iconSize,
        );
        break;
    }
    return Container(
      margin: EdgeInsets.only(right: widget.defaultSize * .5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (context, AsyncSnapshot snapshot) {
        ///offline db connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          List logList = snapshot.data;
          if (logList.isEmpty) {
            return QuietBox(
              defaultSize: widget.defaultSize,
              heading: "Contact Logs",
              subtitle: "Calling people with just one click",
            );
          }
          return ListView.builder(
            itemCount: logList.length,
            itemBuilder: (context, index) {
              Log _log = logList[index];
              bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;
              return CustomTile(
                leading: CachedImage(
                  imageUrl: hasDialled ? _log.receiverPic! : _log.callerPic!,
                  isRound: true,
                  radius: widget.defaultSize * 4.5,
                ),
                title: Text(
                  hasDialled ? _log.receiverName! : _log.callerName!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.defaultSize * 2,
                  ),
                ),
                icon: getIcon(_log.callStatus!),
                subtitle: Text(
                  Utils.formatDateString(_log.timestamp!),
                  style: TextStyle(
                    fontSize: widget.defaultSize * 1.3,
                  ),
                ),
                trailing: Container(),
                onTap: () {},
                onLongPress: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete this log?"),
                    content: Text("Are you sure you want to delete this log?"),
                    actions: [
                      FlatButton(
                        onPressed: () async {
                          Navigator.maybePop(context);
                          await LogRepository.deleteLogs(index);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Text("Yes"),
                      ),
                      FlatButton(
                        onPressed: () async {
                          Navigator.maybePop(context);
                        },
                        child: Text("No"),
                      ),
                    ],
                  ),
                ),
                defaultSize: widget.defaultSize,
                mini: false,
              );
            },
          );
        }
        return Text("No Call Logs");
      },
    );
  }
}

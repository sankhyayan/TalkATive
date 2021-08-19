import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/utils/utilities.dart';

class LastMessageTime extends StatelessWidget {
  final stream;
  final double defaultSize;
  LastMessageTime({required this.stream, required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data!.docs;
            if (docList.isNotEmpty) {
              Message message =
                  Message.fromMap(docList.last.data() as Map<String, dynamic>);
              return Flexible(
                child: Text(
                  Utils.formatTimeToString(message.timestamp!),
                  style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.3),
                ),
              );
            }
            return Text(
              "No Time",
              style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.2),
            );
          }
          return Text(
            "..",
            style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.1),
          );
        });
  }
}

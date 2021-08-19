import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  final double defaultSize;
  LastMessageContainer({required this.stream, required this.defaultSize});
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
              return SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(
                  message.message!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.4),
                ),
              );
            }
            return Text(
              "No Message",
              style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.4),
            );
          }
          return Text(
            "..",
            style: TextStyle(color: Colors.grey, fontSize: defaultSize*1.4),
          );
        });
  }
}

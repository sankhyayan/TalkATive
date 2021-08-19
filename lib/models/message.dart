import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId="", receiverId="", type="", message="", photoUrl="";
  Timestamp? timestamp=Timestamp.now();
  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.photoUrl,
      required this.timestamp});

  //Constructor Will be only called when we wish to send a message
  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.photoUrl,
      required this.timestamp});

  Message.voiceMessage(
      {required this.senderId,
        required this.receiverId,
        required this.type,
        required this.message,
        required this.photoUrl,
        required this.timestamp});

  Map<String, dynamic> toMap() {//text mapping
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map<String, dynamic> toImageMap() {//Image mapping
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['photoUrl']=this.photoUrl;
    return map;
  }

  Map<String, dynamic> toVoiceMap() {//Image mapping
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['photoUrl']=this.photoUrl;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.photoUrl=map['photoUrl'];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/contacts.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/userData.dart';

class ChatMethods {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      firebaseFirestore.collection(USERS_COLLECTION);
  final CollectionReference _messageCollection =
      firebaseFirestore.collection(MESSAGES_COLLECTION);

  ///ADD TXT MESSAGE TO DB
  Future<void> addMessageToDb(
      Message message, UserData sender, UserData receiver) async {
    Map<String, dynamic> map = message.toMap();
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);

    ///ADDING NEW CONTACTS FOR A USER HERE
    await addToContacts(
        senderId: message.senderId, receiverId: message.receiverId);

    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  ///SET IMG MSG TO DB
  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message = Message.imageMessage(
      senderId: senderId,
      receiverId: receiverId,
      type: "image",
      message: "📷",
      photoUrl: url,
      timestamp: Timestamp.now(),
    );
    Map<String, dynamic> map = _message.toImageMap();
    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId!)
        .add(map);

    ///ADDING NEW CONTACTS FOR A USER HERE
    await addToContacts(
        senderId: senderId,
        receiverId: receiverId); //todo optimise add only once
    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId!)
        .add(map);
  }

  ///SET VOICE MSG TO DB
  void setVoiceMsg(String url, String receiverId, String senderId) async {
    Message _message = Message.voiceMessage(
      senderId: senderId,
      receiverId: receiverId,
      type: "voice",
      message: "🎤",
      photoUrl: url,
      timestamp: Timestamp.now(),
    );
    Map<String, dynamic> map = _message.toVoiceMap();
    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId!)
        .add(map);

    ///ADDING NEW CONTACTS FOR A USER HERE
    await addToContacts(
        senderId: senderId,
        receiverId: receiverId); //todo optimise add only once
    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId!)
        .add(map);
  }

  ///TO GET THE PARTICULAR CONTACT FROM THE COLLECTION OF CONTACTS OF EACH USER
  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  ///METHOD TO CALL UPON CONTACT ADDERS
  addToContacts({String? senderId, String? receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId!, receiverId!, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  ///CHECK IF ITS A NEW CONTACT AND ADD TO SENDER'S CONTACT ACCORDINGLY
  Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );
      var receiverMap = receiverContact.toMap(receiverContact);
      getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    } else {
      getContactsDocument(of: senderId, forContact: receiverId)
          .update({"added_on": currentTime});
    }
  }

  ///CHECK IF ITS A NEW CONTACT AND ADD TO RECEIVER'S CONTACT ACCORDINGLY
  Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();
    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );
      var senderMap = senderContact.toMap(senderContact);
      getContactsDocument(of: receiverId, forContact: senderId).set(senderMap);
    } else {
      getContactsDocument(of: receiverId, forContact: senderId)
          .update({"added_on": currentTime});
    }
  }

  ///FETCH ALL THE CONTACTS OF A RESPECTIVE USER
  Stream<QuerySnapshot> fetchContacts({required String userId}) =>
      _userCollection
          .doc(userId)
          .collection(CONTACTS_COLLECTION)
          .orderBy('added_on', descending: true)
          .snapshots();

  ///FETCH MESSAGES BETWEEN 2 USERS
  Stream<QuerySnapshot> fetchLastMessageBetween(
          {required String senderId, required String receiverId}) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy(TIMESTAMP_FIELD)
          .snapshots();
}

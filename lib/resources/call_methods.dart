import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection(CALL_COLLECTION);
  //
  Stream <DocumentSnapshot> callStream({required String uid}) =>
      callCollection.doc(uid).snapshots();
  //
  Future<bool> makeCall({required Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call); //caller's document
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap =
          call.toMap(call); //receiver's document

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({required Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/provider/voiceUploadProvider.dart';
import 'package:skype_clone/resources/chat_methods.dart';

class StorageMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Reference _storageReference = FirebaseStorage.instance.ref();

  ///UPLOADING IMG TO STORAGE AND GETTING DOWNLOAD LINK
  Future<String?> uploadImageToStorage(File image) async {
    try {
      int _dateTime = DateTime.now().microsecondsSinceEpoch;
      await _storageReference
          .child('Images')
          .child('$_dateTime')
          .putFile(image);
      String? url = await _storageReference
          .child('Images')
          .child('$_dateTime')
          .getDownloadURL();
      return url;
    } on Exception catch (e) {
      print("Exception image (uploadToStorage): $e");
      return null;
    }
  }
  ///UPLOADING VOICE TO STORAGE AND GETTING DOWNLOAD LINK
  Future<String?> uploadVoiceToStorage(File voice) async {
    try {
      int _dateTime = DateTime.now().microsecondsSinceEpoch;
      await _storageReference
          .child('VoiceNotes')
          .child('$_dateTime')
          .putFile(voice);
      String? url = await _storageReference
          .child('VoiceNotes')
          .child('$_dateTime')
          .getDownloadURL();
      return url;
    } on Exception catch (e) {
      print("Exception voice (uploadToStorage): $e");
      return null;
    }
  }

  ///IMG UPLOAD HELPER AND IMG PROVIDER UPDATER
  void uploadImage(
      {required File image,
      required String receiverId,
      required String senderId,
      required ImageUploadProvider imageUploadProvider}) async {
    final chatMethods=ChatMethods();
    imageUploadProvider.setToLoading();
    String? url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    chatMethods.setImageMsg(url!, receiverId, senderId);
  }
///VOICE UPLOAD HELPER AND VOICE PROVIDER UPDATER
  void uploadVoice(
      {required File voice,
        required String receiverId,
        required String senderId,
        required VoiceUploadProvider voiceUploadProvider}) async {
    final chatMethods=ChatMethods();
    voiceUploadProvider.setToLoading();
    String? url = await uploadVoiceToStorage(voice);//todo set voice message in chat methods
    voiceUploadProvider.setToIdle();
    chatMethods.setVoiceMsg(url!, receiverId, senderId);

  }
}

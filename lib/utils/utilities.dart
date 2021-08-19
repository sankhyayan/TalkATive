import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/enum/userstate.dart';

class Utils {
  static String? getUsername(String? email) {
    return "live:${email!.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastnameInitial = nameSplit[1][0];
    return firstNameInitial + lastnameInitial;
  }

  static Future<File?> pickImage({required ImageSource source}) async {
    XFile? pickedImage = await ImagePicker().pickImage(
        source: source, maxHeight: 400, maxWidth: 400, imageQuality: 75);
    return fileMaker(pickedImage);
  }

  static Future<File?> fileMaker(XFile? imageToAdd) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(10000);
    Im.Image? image = Im.decodeImage(await imageToAdd!.readAsBytes());
    return File('$path/img_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image!));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int num) {
    switch (num) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }

  static String formatTimeToString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    var formatDate = DateFormat().add_jm();
    return formatDate.format(dateTime);
  }

}

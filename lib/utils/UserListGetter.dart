import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/resources/auth_methods.dart';


class UserListGetter{
  final AuthMethods _authMethods=AuthMethods();
  List<UserData> userList = [];
  Future<List<UserData>> getUserList() async {
    await _authMethods.getCurrentUser().then((User? user) async {
      await _authMethods.fetchAllUsers(user).then((List<UserData> list) {
          userList = list;
      });
    });
    return userList;
  }
}
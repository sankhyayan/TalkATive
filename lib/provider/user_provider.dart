import 'package:flutter/cupertino.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods=AuthMethods();
  UserData _currentUser = UserData(
    uid: "",
    name: "",
    email: "",
    username: "",
    status: "",
    state: 0,
    profilePhoto: "",
  );
  UserData get getUser => _currentUser;
  Future<void> refreshUser() async {
    UserData userData=await _authMethods.getUserDetails();
    _currentUser=userData;
    notifyListeners();
  }
}

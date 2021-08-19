import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/screens/Search/searchscreen.dart';
import 'package:skype_clone/utils/UserListGetter.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:provider/provider.dart';
class QuietBox extends StatelessWidget {
  final double defaultSize;
  final String heading;
  final String subtitle;
  QuietBox({required this.heading,
    required this.subtitle,required this.defaultSize});
  final UserListGetter _userListGetter = UserListGetter();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultSize * 2.5),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(
              vertical: defaultSize * 3.5, horizontal: defaultSize * 2.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: defaultSize * 3,
                ),
              ),
              SizedBox(
                height: defaultSize * 2.5,
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: defaultSize * .12,
                  fontWeight: FontWeight.normal,
                  fontSize: defaultSize * 1.8,
                ),
              ),
              SizedBox(
                height: defaultSize * 2.5,
              ),
              FlatButton(
                onPressed: () async {
                  List<UserData> userList = await _userListGetter.getUserList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                userList: userList,
                                sender: userProvider.getUser,
                              )));
                },
                child: Text("START SEARCHING"),
                color: UniversalVariables.lightBlueColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

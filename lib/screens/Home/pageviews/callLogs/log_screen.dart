import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/screens/Home/pageviews/callLogs/widgets/floating_column.dart';
import 'package:skype_clone/screens/Home/pageviews/callLogs/widgets/logListContainer.dart';
import 'package:skype_clone/screens/Search/searchscreen.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:skype_clone/utils/UserListGetter.dart';
import 'package:skype_clone/widgets/skype_bar.dart';

final UserListGetter _userListGetter = UserListGetter();

class LogScreen extends StatelessWidget {
  final double defaultSize;
  LogScreen({required this.defaultSize});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return PickupLayout(
      defaultSize: defaultSize,
      scaffold: Scaffold(
        backgroundColor: Colors.black,
        appBar: SkypeAppBar(
          defaultSize: defaultSize,
          title: "Calls",
          actions: <Widget>[
            IconButton(
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
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(defaultSize: defaultSize,),
        body: Padding(
          padding: EdgeInsets.only(left: defaultSize*1.5),
          child: LogListContainer(defaultSize: defaultSize,),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/screens/Search/searchscreen.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:skype_clone/utils/UserListGetter.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/newChatButton.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/usercircle.dart';
import 'package:skype_clone/widgets/skype_bar.dart';
import 'chatListViewBuilder.dart';

final UserListGetter _userListGetter = UserListGetter();

class ChatListScreen extends StatelessWidget {
  final double defaultSize;
  const ChatListScreen({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return PickupLayout(
      defaultSize: defaultSize,
      scaffold: Scaffold(
        backgroundColor: Colors.black,
        appBar: SkypeAppBar(
          title: UserCircle(
            defaultSize: defaultSize,
          ),
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
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ], defaultSize: defaultSize,
        ),
        floatingActionButton: NewChatButton(
          defaultSize: defaultSize,
        ),
        body: ChatListContainer(
          defaultSize: defaultSize,
        ),
      ),
    );
  } //MAIN CONTEXT

}

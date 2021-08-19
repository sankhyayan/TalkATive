import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/contacts.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/LastMessageContainer.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/lastMessageTime.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/online_dot_indicator.dart';
import 'package:skype_clone/screens/chatScreen/chatScreen.dart';
import 'package:skype_clone/screens/chatScreen/widgets/cached_image.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final double defaultSize;
  final AuthMethods _authMethods = AuthMethods();
  ContactView({required this.defaultSize, required this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      initialData: UserData(
          uid: "",
          name: "",
          email: "",
          username: "",
          status: "",
          state: 0,
          profilePhoto: ""),
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.data!.uid != "" && snapshot.hasData) {
          UserData user = snapshot.data!;
          return ViewLayout(
            receiver: user,
            defaultSize: defaultSize,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserData receiver;
  final double defaultSize;
  final ChatMethods _chatMethods = ChatMethods();
  ViewLayout({required this.receiver, required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final stream=_chatMethods.fetchLastMessageBetween(
        senderId: userProvider.getUser.uid!, receiverId: receiver.uid!);
    return CustomTile(
      defaultSize: defaultSize,
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                  receiver: receiver, currentUser: userProvider.getUser))),
      onLongPress: () {},
      title: Text(
        receiver.name ?? "..",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Arial",
          fontSize: defaultSize * 1.4,
        ),
      ),
      subtitle: LastMessageContainer(
        defaultSize: defaultSize,
        stream: stream,
      ),
      leading: Container(
        constraints: BoxConstraints(
            maxHeight: defaultSize * 6, maxWidth: defaultSize * 6),
        child: Stack(
          children: [
            CachedImage(
              imageUrl: receiver.profilePhoto!,
              radius: defaultSize * 8,
              isRound: true,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: OnlineDotIndicator(
                  defaultSize: defaultSize, uid: receiver.uid!),
            ),
          ],
        ),
      ),
      icon: Container(),
      trailing: LastMessageTime(
        stream: stream,
        defaultSize: defaultSize,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/shimmering_logo.dart';
import 'package:skype_clone/screens/Login/loginscreen.dart';
import 'package:skype_clone/screens/chatScreen/widgets/cached_image.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:provider/provider.dart';

class UserDetailsContainer extends StatelessWidget {
  final double defaultSize;
  const UserDetailsContainer({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        ///NAVIGATE USER TO LOGIN PAGE SO THAT THEY CANT PRESS BACK BUTTON AND COME TO CHAR SCREEN
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }
    }
    return Container(
      margin: EdgeInsets.only(top: defaultSize * 2.5),
      child: Column(
        children: [
          CustomAppBar(
              title: ShimmeringLogo(
                defaultSize: defaultSize,
              ),
              leading: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              actions: [
                FlatButton(
                    onPressed: () => signOut(),
                    child: Text(
                      "SIGN OUT",
                      style: TextStyle(
                          color: Colors.white, fontSize: defaultSize * 1.4),
                    ))
              ],
              centerTitle: true,
              defaultSize: defaultSize,
              color: Colors.black),
          UserDetailsBody(
            defaultSize: defaultSize,
          ),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  final double defaultSize;
  const UserDetailsBody({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserData userData = userProvider.getUser;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: defaultSize * 2, horizontal: defaultSize * 2),
      child: Row(
        children: [
          CachedImage(
            imageUrl: userData.profilePhoto!,
            isRound: true,
            radius: defaultSize * 5,
          ),
          SizedBox(
            width: defaultSize * 1.5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData.name!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: defaultSize * 1.8,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: defaultSize,
              ),
              Text(
                userData.email!,
                style: TextStyle(
                  fontSize: defaultSize * 1.4,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

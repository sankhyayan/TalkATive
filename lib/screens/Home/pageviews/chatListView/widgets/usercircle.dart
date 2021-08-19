import 'package:flutter/material.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/user_details_container.dart';
import 'package:skype_clone/utils/utilities.dart';

//A widget to provide user circle and user online or offline
class UserCircle extends StatelessWidget {
  final double defaultSize;
  UserCircle({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) => UserDetailsContainer(defaultSize: defaultSize,),
          isScrollControlled: true,
          backgroundColor: Colors.black),
      child: Container(
        height: defaultSize * 4,
        width: defaultSize * 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultSize * 2),
          color: Color(0xff272c35),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUser.name!),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0077d7),
                  fontSize: defaultSize * 1.3,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: defaultSize * 1.2,
                width: defaultSize * 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.black, width: defaultSize * .2),
                  color: Color(0xff46dc64),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

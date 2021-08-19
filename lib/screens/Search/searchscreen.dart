import 'package:flutter/cupertino.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/sizeConfig.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/chatScreen/chatScreen.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/customTile.dart';

class SearchScreen extends StatefulWidget {
  final List<UserData> userList;
  final UserData sender;
  SearchScreen({required this.userList,required this.sender});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;
    return PickupLayout(
      defaultSize: defaultSize,
      scaffold: Scaffold(
        backgroundColor: Colors.black,
        appBar: searchAppBar(context, defaultSize),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
          child: buildSuggestionsList(query, defaultSize),
        ),
      ),
    );
  } //MAIN BUILD

  searchAppBar(BuildContext context, double defaultSize) {
    //custom search app bar
    return NewGradientAppBar(
        gradient: LinearGradient(colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd
        ]),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + (defaultSize * 2)),
          child: Padding(
            padding: EdgeInsets.only(left: defaultSize * 2),
            child: TextField(
              controller: searchController,
              onChanged: (text) {
                setState(() {
                  query = text;
                });
              },
              cursorColor: Colors.white,
              autofocus: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: defaultSize * 3.5,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: defaultSize * 3.5,
                  color: Color(0x88FFFFFF),
                ),
              ),
            ),
          ),
        ));
  } //search app bar method

  buildSuggestionsList(String query, double defaultSize) {
    final List<UserData> suggestionList = query.isEmpty
        ? []
        : widget.userList.where(
            (UserData user) {
              String _getUserName = user.username!.toLowerCase();
              String _query = query.toLowerCase();
              String _getName = user.name!.toLowerCase();
              bool matchUserName = _getUserName.contains(_query);
              bool matchesName = _getName.contains(_query);
              return (matchUserName || matchesName);
            },
          ).toList();
    return ListView.builder(
      itemBuilder: ((context, index) {
        UserData searchedUser = UserData(
            uid: suggestionList[index].uid,
            name: suggestionList[index].name,
            email: suggestionList[index].email,
            username: suggestionList[index].username,
            status: suggestionList[index].status,
            state: suggestionList[index].state,
            profilePhoto: suggestionList[index].profilePhoto);
        return CustomTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto!),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.name!,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Container(),
          subtitle: Text(
            searchedUser.username!,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Container(),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiver: searchedUser,
    currentUser: widget.sender,
                        )));
          },
          onLongPress: () {},
          defaultSize: defaultSize,
          mini: false,
        );
      }),
      itemCount: suggestionList.length,
    );
  } //Search suggestion method
}

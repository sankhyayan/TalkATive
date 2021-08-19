import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/enum/userstate.dart';
import 'package:skype_clone/models/sizeConfig.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/Home/pageviews/callLogs/log_screen.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/chat_list_creen.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late PageController pageController;
  int _page = 0;
  late UserProvider userProvider;
  final AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      ///ONLY PLACE WHERE USER IS REFRESHED TO GET NEW USER HENCE AWAIT ONLY HERE(this change prevents non green state when app is opened)
      if (userProvider.getUser.uid!.isNotEmpty) {
        _authMethods.setUserState(
          userId: userProvider.getUser.uid!,
          userState: UserState.Online,
        );
      }
      LogRepository.init(isHive: true, dbName: userProvider.getUser.uid!);
    });
    WidgetsBinding.instance!.addObserver(this);
    pageController = PageController();
  } //Page Controller initializer

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)  {
    String currentUserId = userProvider.getUser.uid!;
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId.isNotEmpty
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("ONLINE"); //APP USED AGAIN ONLINE
        break;
      case AppLifecycleState.inactive:
        currentUserId.isNotEmpty
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("OFFLINE"); //APP OFFLINE
        break;
      case AppLifecycleState.paused: //APP IN BACKGROUND
        currentUserId.isNotEmpty
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("WAITING AROUND"); //NOT ACTIVE USER
        break;
      case AppLifecycleState.detached:
        currentUserId.isNotEmpty
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("OFFLINE"); //ANOTHER OFFLINE INSTANCE
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  } //Page change handler

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        physics: PageScrollPhysics(),
        children: [
          PickupLayout(
            defaultSize: defaultSize,
            scaffold: ChatListScreen(
              defaultSize: defaultSize,
            ),
          ),
          PickupLayout(
            defaultSize: defaultSize,
            scaffold: LogScreen(
              defaultSize: defaultSize,
            ),
          ),
          PickupLayout(
            defaultSize: defaultSize,
            scaffold: Scaffold(
              body: Center(
                  child: Text("Phone List Screen",
                      style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
        controller: pageController,
        onPageChanged: (page) => onPageChanged(page),
      ),
      //todo after call pickup bottom nav bar icon doesn't change according to page
      bottomNavigationBar: PickupLayout(
        defaultSize: defaultSize,
        scaffold: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultSize),
            child: CupertinoTabBar(
              backgroundColor: Colors.black,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                ),
              ],
              onTap: (page) => navigationTapped(page),
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skype_clone/models/sizeConfig.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/screens/Home/homescreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: loginButton(defaultSize: defaultSize),
          ),
          isLoginPressed
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget loginButton({required double defaultSize}) {
    return Shimmer.fromColors(
      baseColor: UniversalVariables.gradientColorEnd,
      highlightColor: Colors.white,
      child: FlatButton(
        splashColor: Colors.white.withOpacity(.5),
        padding: EdgeInsets.symmetric(
            vertical: defaultSize * .4, horizontal: defaultSize),
        onPressed: () => performLogin(),
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: defaultSize * 4.5,
            fontWeight: FontWeight.w900,
            letterSpacing: defaultSize * 0.12,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultSize * 1.5),
          bottomRight: Radius.circular(defaultSize * 1.5),
          topRight: Radius.circular(defaultSize * 1.5),
          bottomLeft: Radius.circular(defaultSize * 1.5),
        )),
      ),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _authMethods.googleSignIn().then((UserCredential user) {
      authenticateUser(user.user);
    });
  }

  void authenticateUser(User? user) {
    setState(() {
      isLoginPressed = false;
    });
    //If new user then add to db
    _authMethods.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/provider/voiceUploadProvider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/screens/Home/homescreen.dart';
import 'package:skype_clone/screens/Login/loginscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods=AuthMethods();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ImageUploadProvider()),
        ChangeNotifierProvider(create: (_)=>VoiceUploadProvider()),
        ChangeNotifierProvider(create: (_)=>UserProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        title: "Skype Clone",
        initialRoute: "/",
        home: Scaffold(
          body: FutureBuilder(
            future: _authMethods.getCurrentUser(),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              return snapshot.hasData? HomeScreen() : LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}

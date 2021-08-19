import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/enum/userstate.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/utils/utilities.dart';
class AuthMethods {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final CollectionReference _userCollection =
      firebaseFirestore.collection(USERS_COLLECTION);

  ///get current user
  Future<User?> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser!;
    return currentUser;
  }

  ///USER DETAILS
  Future<UserData> getUserDetails() async {
    User? _currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(_currentUser!.uid).get();
    return UserData.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  ///GETTING USER DETAILS BY ID ONLY
  Future<UserData> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return UserData.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } on Exception catch (e) {
      print(e);
      return UserData(
          uid: "",
          name: "",
          email: "",
          username: "",
          status: "",
          state: 0,
          profilePhoto: "");
    }
  }

  ///GOOGLE SIGN IN
  Future<UserCredential> googleSignIn() async {
    final GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount!.authentication;

    ///GOOGLE OAuth
    final credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  ///CHECK FOR PREVIOUS USER AND IF NOT ADD AS NEW
  Future<bool> authenticateUser(User? user) async {
    QuerySnapshot result = await firebaseFirestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user!.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  ///ADDING USER DETAILS IF NEW USER
  Future<void> addDataToDb(User? currentUser) async {
    String? username = Utils.getUsername(currentUser!.email);
    UserData user = UserData(
        uid: currentUser.uid,
        name: currentUser.displayName,
        email: currentUser.email,
        username: username,
        status: "",
        state: 0,
        profilePhoto: currentUser.photoURL);
    firebaseFirestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  ///GETTING ALL USERS FOR SEARCH LIST
  Future<List<UserData>> fetchAllUsers(User? currentUser) async {//todo optimise get only once
    //Getting users except current user for display in search
    List<UserData> userList = <UserData>[];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser!.uid) {
        userList.add(UserData.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  ///GOOGLE SIGN OUT
  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } on Exception catch (e) {
       print(e);
       return false;
    }
  }

  ///SETTING USER STATE
  void setUserState({required String userId, required UserState userState}) async{
    int stateNum = Utils.stateToNum(userState);
    await _userCollection.doc(userId).update({"state": stateNum});
  }

  Stream<DocumentSnapshot>getUserOnlineOffline({required String uid})=>_userCollection.doc(uid).snapshots();
}
